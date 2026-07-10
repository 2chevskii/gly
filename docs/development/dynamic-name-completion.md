# Dynamic name completion research

## Scope

This note evaluates tab completion for names registered in the current `gly`
module session:

- `Set-GlyTheme -Name`;
- `Set-GlyGlyphSet -Name`;
- `Set-GlyConfiguration -Theme`;
- `Set-GlyConfiguration -GlyphSet`.

The other `Set-GlyConfiguration` parameters do not use a session registry.
`SizeFormat`, `DateFormat`, and `StyleRenderer` already complete from their
`ValidateSet` attributes. The Boolean parameters keep normal PowerShell binding
behavior and are outside this name-completion change.

This is design research only. It does not implement the completers.

## Current implementation

`Initialize-GlyThemeRegistry` and `Initialize-GlyGlyphSetRegistry` create
module-private ordered dictionaries in `$script:GlyThemes` and
`$script:GlyGlyphSets`. `Register-GlyTheme` and `Register-GlyGlyphSet` mutate
those dictionaries for the lifetime of the imported module. The three setter
commands validate names against the dictionaries when invoked.

This makes completion naturally dynamic: a completer should read the relevant
dictionary every time PowerShell asks for completions, not capture a copy of its
keys during module import. A newly registered item then becomes available on
the next Tab or Ctrl+Space operation without reimporting the module.

Completion must remain advisory. The existing setter validation must continue
to reject unknown names because a caller can bypass completion, registry state
can change, and scripts are not interactive.

## PowerShell mechanisms

PowerShell supplies two relevant mechanisms:

1. `[ArgumentCompleter({ ... })]` attaches a script block to parameter metadata.
2. `Register-ArgumentCompleter` registers a script block for a command and
   parameter at run time.

Both receive the command name, parameter name, word to complete, command AST,
and fake bound parameters for PowerShell commands. The completer runs when
completion is requested, so it can observe current session state. It must emit
results individually through the pipeline; returning an array as one object is
interpreted as one completion. It may emit strings or
`System.Management.Automation.CompletionResult` objects.

`CompletionResult` is preferable here because Ctrl+Space can distinguish a
built-in item from a user-registered item in its tooltip while inserting only
the name.

## Options considered

### Inline `ArgumentCompleter` using public getters

Each relevant parameter could carry an inline attribute that calls
`Get-GlyTheme` or `Get-GlyGlyphSet` and selects `Name`.

Advantages:

- completion metadata is removed with the command;
- the implementation is local to each parameter;
- the public getters naturally reach current module state.

Disadvantages:

- the same logic is repeated on four parameters unless it calls another
  command;
- an attribute script block invoked by completion cannot safely assume direct
  access to the defining module's `$script:` variables or private helpers;
- the getters return detached typed copies and expand built-in definitions,
  doing substantially more work than name completion needs.

An exploratory local measurement against the current 90 built-in themes used
30 calls to `TabExpansion2`. A completer based on `Get-GlyTheme` had a median of
about 230 ms on this development machine. This is not a formal benchmark, but
it is enough to reject repeated full-object conversion on a latency-sensitive
interactive path.

### Module-time `Register-ArgumentCompleter`

The module can register module-bound script blocks after initializing both
registries. Those blocks can call a private helper and read the dictionary keys
directly. The lookup therefore stays dynamic without constructing theme or
glyph-set copies.

Advantages:

- one private implementation can serve all four parameters;
- direct key access is cheap;
- registration occurs once per import;
- both named and positional use of `Set-GlyTheme` and `Set-GlyGlyphSet` are
  completed by a parameter registration;
- exploratory testing also completed a module-qualified command such as
  `gly\Set-GlyTheme`.

Disadvantages:

- PowerShell has no corresponding public `Unregister-ArgumentCompleter` cmdlet;
- a registered completer remains in the runspace after `Remove-Module` and its
  module-bound script block can retain the old module session state;
- importing the module again must overwrite the registrations with blocks bound
  to the new module instance.

A direct-key prototype had a median of about 1.8 ms over the same 30-call local
probe. Treat these figures as directional only; hardware, host configuration,
PSReadLine, and warm-up affect completion timing.

### Class-based completer

An `IArgumentCompleter` implementation gives stronger types and reusable code,
but an instance still needs a supported bridge to mutable module-private state.
A static/global registry bridge would duplicate ownership and complicate module
reloads. Calling the public getters restores the performance problem. This adds
complexity without a benefit for four script-function parameters.

### Dynamic `ValidateSet`

A class implementing `IValidateSetValuesGenerator` can provide values that also
participate in completion. It is not recommended here:

- the setters already perform registry validation with project-specific error
  messages;
- it couples completion to validation and changes binding-time behavior;
- it has the same module-state access problem as a class-based completer;
- replacing the current explicit validation is unnecessary risk.

`ArgumentCompletions` and a literal `ValidateSet` are static, so neither can
reflect items registered later in the session.

## Recommended approach

Use `Register-ArgumentCompleter` during module initialization, after
`Initialize-GlyThemeRegistry` and `Initialize-GlyGlyphSetRegistry`, with a
private helper that reads keys from the relevant live dictionary.

Register these command/parameter pairs:

| Command | Parameter | Registry |
| --- | --- | --- |
| `Set-GlyTheme` | `Name` | `$script:GlyThemes` |
| `Set-GlyGlyphSet` | `Name` | `$script:GlyGlyphSets` |
| `Set-GlyConfiguration` | `Theme` | `$script:GlyThemes` |
| `Set-GlyConfiguration` | `GlyphSet` | `$script:GlyGlyphSets` |

Keep registration in one private function, for example
`Register-GlyArgumentCompleters`, so normal import and coverage-mode import use
the same path. Re-register on every import; PowerShell replaces the existing
entry for the same command and parameter.

The following is an implementation sketch, not production code:

```powershell
function Get-GlyRegistryNameCompletion {
  param(
    [Parameter(Mandatory)]
    [System.Collections.IDictionary] $Registry,

    [Parameter(Mandatory)]
    [string] $WordToComplete,

    [Parameter(Mandatory)]
    [string] $ItemLabel
  )

  $prefix = $WordToComplete.TrimStart([char[]] @("'", '"'))
  $escapedPrefix = [System.Management.Automation.WildcardPattern]::Escape($prefix)

  foreach ($name in $Registry.Keys) {
    if ($name -notlike "$escapedPrefix*") {
      continue
    }

    # Always quoting is valid for simple names and also supports registered
    # names containing spaces or apostrophes.
    $completionText = "'$($name -replace "'", "''")'"
    $origin = if ($Registry[$name].BuiltIn) { 'Built-in' } else { 'Registered' }

    [System.Management.Automation.CompletionResult]::new(
      $completionText,
      $name,
      [System.Management.Automation.CompletionResultType]::ParameterValue,
      "$origin gly $ItemLabel"
    )
  }
}

function Register-GlyArgumentCompleters {
  $themeCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    if (-not (Get-Module -Name gly)) { return }
    Get-GlyRegistryNameCompletion $script:GlyThemes $wordToComplete 'theme'
  }

  $glyphSetCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    if (-not (Get-Module -Name gly)) { return }
    Get-GlyRegistryNameCompletion $script:GlyGlyphSets $wordToComplete 'glyph set'
  }

  Register-ArgumentCompleter -CommandName Set-GlyTheme `
    -ParameterName Name -ScriptBlock $themeCompleter
  Register-ArgumentCompleter -CommandName Set-GlyGlyphSet `
    -ParameterName Name -ScriptBlock $glyphSetCompleter
  Register-ArgumentCompleter -CommandName Set-GlyConfiguration `
    -ParameterName Theme -ScriptBlock $themeCompleter
  Register-ArgumentCompleter -CommandName Set-GlyConfiguration `
    -ParameterName GlyphSet -ScriptBlock $glyphSetCompleter
}
```

The production implementation should avoid positional calls to the private
helper if its parameter order is not deliberately part of the internal design.
The sketch uses them only to keep the focus on completion behavior.

### Lifecycle mitigation

Because registration survives module removal, the completer should defensively
verify that the command currently being completed is still exported by `gly`
before returning values. This prevents stale suggestions if another command
with the same name appears later in the runspace. The old registered block can
still retain the removed module instance until it is overwritten or the
runspace ends; that is a platform limitation of this approach and should be
covered by a small manual removal/reimport check.

Do not attempt to edit PowerShell's internal completer tables to unregister the
blocks. Those tables are not a supported API.

## Filtering and insertion details

- Match case-insensitively, consistent with ordinary PowerShell name use and
  the current registry lookup behavior.
- Escape `$wordToComplete` before wildcard matching so characters such as `[`
  are treated literally.
- Account for an opening single or double quote in `$wordToComplete`.
- Quote inserted values and double embedded apostrophes. Registration currently
  permits any non-whitespace name, including names with spaces.
- Preserve registry order. It keeps built-ins in their declared order and user
  registrations in session order. Alphabetic sorting is possible, but it would
  be a new interaction decision rather than a completion requirement.
- Avoid writing errors, verbose output, or other streams from the completer.
  Completion should fail quietly if the module command is no longer active.

## Version compatibility

The module targets PowerShell 7.0 or newer. `Register-ArgumentCompleter`, the
five-argument PowerShell-command script block contract, `CompletionResult`, and
`TabExpansion2` are available within that supported range. No Windows
PowerShell 5.1 compatibility work is needed.

The proposed design does not require newer features such as native fallback
completion. It registers ordinary PowerShell command parameters and must always
specify both `-CommandName` and `-ParameterName`.

Hosts can replace or customize `TabExpansion2`, and PSReadLine controls the
interactive presentation. Tests should assert the engine completion results,
not terminal-specific menu rendering or key bindings.

## Test strategy

Add focused Pester tests that import the built module and inspect
`TabExpansion2` results:

1. `Set-GlyTheme -Name D` includes a built-in such as `DefaultDark`.
2. Positional `Set-GlyTheme D` returns the same candidates.
3. `Set-GlyGlyphSet -Name U` includes `Unicode`.
4. `Set-GlyConfiguration -Theme Cat` and
   `Set-GlyConfiguration -GlyphSet A` use the correct, separate registries.
5. After `Register-GlyTheme`, its new name appears without reimporting.
6. After `Register-GlyGlyphSet`, its new name appears without reimporting.
7. A partial prefix excludes nonmatching values and treats wildcard metacharacters
   literally.
8. A registered name containing a space and apostrophe yields syntactically
   valid quoted `CompletionText` and the original `ListItemText`.
9. Result objects have `ParameterValue` type and useful built-in/registered
   tooltips.
10. Unknown names still fail at command invocation; completion does not replace
    validation.
11. `Import-Module -Force` updates completion to the new module instance rather
    than returning values captured before reimport.
12. After `Remove-Module`, a same-named unrelated function receives no stale gly
    suggestions if the defensive ownership check is implemented.

A compact assertion helper can obtain results with:

```powershell
$line = 'Set-GlyTheme -Name Def'
$matches = (TabExpansion2 -inputScript $line -cursorColumn $line.Length).CompletionMatches
```

Use `CompletionText`, `ListItemText`, `ResultType`, and `ToolTip` for assertions.
Do not assert measured milliseconds in the normal suite. If completion latency
becomes a regression concern, add a separate benchmark scenario with warm-up
and broad thresholds rather than a timing-sensitive unit test.

## Limitations and follow-up decisions

- Registered completion is runspace-local, matching gly's in-memory session
  configuration. It does not propagate to another PowerShell process or
  runspace unless the module is imported there.
- Completion reflects only registrations visible to the imported module
  instance. This is the desired behavior when multiple runspaces load gly.
- PowerShell offers no supported unregister command, so the lifecycle mitigation
  reduces stale behavior but cannot eagerly release the old module closure.
- Completion suggestions do not guarantee that a later invocation succeeds if
  registry state changes between completion and execution. Existing setter
  validation remains authoritative.
- The current project has no unregister-theme or unregister-glyph-set commands.
  If those are added later, invocation-time lookup will naturally stop
  suggesting removed items.
- Tooltips should remain short because host support and display width vary.

## Sources

- Microsoft Learn, [about_Functions_Argument_Completion](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_functions_argument_completion)
- Microsoft Learn, [Register-ArgumentCompleter](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/register-argumentcompleter)
- Microsoft Learn, [TabExpansion2](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/tabexpansion2)
- Microsoft Learn, [about_Tab_Expansion](https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_tab_expansion)
- Microsoft Learn, [CompletionResult class](https://learn.microsoft.com/dotnet/api/system.management.automation.completionresult)
- Microsoft Learn, [CompletionResultType enum](https://learn.microsoft.com/dotnet/api/system.management.automation.completionresulttype)

The PowerShell documentation was resolved and queried through Context7 using
the official `/microsoftdocs/powershell-docs` source. Repository-specific
conclusions were checked against the current implementation and local
PowerShell completion probes.
