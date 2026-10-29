Hide
Wait+Line /^>\s*$/
Type ". ./scripts/capture/Initialize-GlyCapture.ps1"
Enter
Wait+Screen /GLY_CAPTURE_READY/
Wait+Line /^PS>\s*$/
Type "Clear-Host"
Enter
Show
