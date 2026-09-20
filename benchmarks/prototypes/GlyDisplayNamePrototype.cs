using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

public sealed class GlyPrototypeRule
{
    private readonly Regex[] wildcardPatterns;

    public GlyPrototypeRule(
        string token,
        string kind,
        string name,
        string[] extensions,
        string[] globs,
        FileAttributes[] attributes)
    {
        Token = token;
        Kind = string.IsNullOrEmpty(kind) ? null : kind;
        Name = string.IsNullOrEmpty(name) ? null : name;
        Extensions = extensions;
        Attributes = attributes;

        var patterns = new List<Regex>();
        var exactNames = new List<string>();
        foreach (string glob in globs)
        {
            if (glob.Contains('*') || glob.Contains('?'))
            {
                string pattern = "^" + Regex.Escape(glob).Replace("\\*", ".*").Replace("\\?", ".") + "$";
                patterns.Add(new Regex(pattern, RegexOptions.IgnoreCase | RegexOptions.CultureInvariant | RegexOptions.Compiled));
            }
            else
            {
                exactNames.Add(glob);
            }
        }

        ExactNames = exactNames.ToArray();
        wildcardPatterns = patterns.ToArray();
    }

    public string Token { get; }
    public string Kind { get; }
    public string Name { get; }
    public string[] Extensions { get; }
    public string[] ExactNames { get; }
    public FileAttributes[] Attributes { get; }

    public bool Matches(string kind, string name, FileAttributes attributes)
    {
        if (Kind != null && !string.Equals(Kind, kind, StringComparison.Ordinal))
        {
            return false;
        }

        if (Name != null && !string.Equals(Name, name, StringComparison.Ordinal))
        {
            return false;
        }

        if (Extensions.Length > 0)
        {
            bool matched = false;
            foreach (string extension in Extensions)
            {
                if (name.EndsWith(extension, StringComparison.OrdinalIgnoreCase))
                {
                    matched = true;
                    break;
                }
            }

            if (!matched)
            {
                return false;
            }
        }

        if (ExactNames.Length > 0 || wildcardPatterns.Length > 0)
        {
            bool matched = false;
            foreach (string exactName in ExactNames)
            {
                if (string.Equals(name, exactName, StringComparison.OrdinalIgnoreCase))
                {
                    matched = true;
                    break;
                }
            }

            if (!matched)
            {
                foreach (Regex pattern in wildcardPatterns)
                {
                    if (pattern.IsMatch(name))
                    {
                        matched = true;
                        break;
                    }
                }
            }

            if (!matched)
            {
                return false;
            }
        }

        foreach (FileAttributes required in Attributes)
        {
            if ((attributes & required) == 0)
            {
                return false;
            }
        }

        return true;
    }
}

public sealed class GlyDisplayNamePrototype
{
    private readonly GlyPrototypeRule[] rules;
    private readonly IReadOnlyDictionary<string, string> glyphs;
    private readonly string fileStyle;
    private readonly string directoryStyle;
    private readonly string hiddenStyle;
    private readonly string readOnlyStyle;

    public GlyDisplayNamePrototype(
        GlyPrototypeRule[] rules,
        IReadOnlyDictionary<string, string> glyphs,
        IReadOnlyDictionary<string, string> palette)
    {
        this.rules = rules;
        this.glyphs = glyphs;
        fileStyle = ToAnsiStyle(palette["File"], false);
        directoryStyle = ToAnsiStyle(palette["Directory"], true);
        hiddenStyle = ToAnsiStyle(palette["Hidden"], false);
        readOnlyStyle = ToAnsiStyle(palette["ReadOnly"], false);
    }

    public string Render(FileSystemInfo item)
    {
        FileAttributes attributes = item.Attributes;
        if ((attributes & FileAttributes.ReparsePoint) != 0)
        {
            throw new NotSupportedException("This prototype does not render symbolic links.");
        }

        string name = item.Name;
        string kind = item is DirectoryInfo ? "Directory" : "File";
        string token = "Default";
        for (int index = rules.Length - 1; index >= 0; index--)
        {
            if (rules[index].Matches(kind, name, attributes))
            {
                token = rules[index].Token;
                break;
            }
        }

        if (!glyphs.TryGetValue(token, out string glyph))
        {
            glyph = glyphs["Default"];
        }

        string displayName = string.IsNullOrEmpty(glyph) ? name : glyph + " " + name;
        string style = (attributes & FileAttributes.Hidden) != 0 ? hiddenStyle
            : (attributes & FileAttributes.ReadOnly) != 0 ? readOnlyStyle
            : kind == "Directory" ? directoryStyle
            : fileStyle;

        return style + displayName + "\u001b[0m";
    }

    private static string ToAnsiStyle(string hexColor, bool bold)
    {
        int red = Convert.ToInt32(hexColor.Substring(1, 2), 16);
        int green = Convert.ToInt32(hexColor.Substring(3, 2), 16);
        int blue = Convert.ToInt32(hexColor.Substring(5, 2), 16);
        string codes = bold ? "1;38;2" : "38;2";
        return "\u001b[" + codes + ";" + red + ";" + green + ";" + blue + "m";
    }
}
