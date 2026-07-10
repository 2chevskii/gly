function ConvertTo-GlyPreviewText {
  param(
    [AllowEmptyString()]
    [string] $Text,

    [GlyStyle] $Style
  )

  $prefix = ConvertTo-GlyAnsiStyle -Style $Style
  if ([string]::IsNullOrEmpty($prefix)) {
    return $Text
  }

  return "$prefix$Text$([char]27)[0m"
}
