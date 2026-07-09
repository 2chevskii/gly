function Test-GlyAnsiOutputSupported {
  if ($Host.Name -eq 'ServerRemoteHost') {
    return $false
  }

  return $true
}
