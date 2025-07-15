# PowerShell Defrag Script for C: Drive (HDD only)
$driveLetter = "C"
$logPath = "C:\DefragLog.txt"

# Get volume and media type
try {
    $volume = Get-Volume -DriveLetter $driveLetter
    $mediaType = ($volume | Get-PhysicalDisk).MediaType
} catch {
    Add-Content $logPath "[$(Get-Date)] ERROR: Could not determine media type for drive $driveLetter. $_"
    exit 1
}

# Defrag if not SSD
if ($mediaType -ne "SSD") {
    Add-Content $logPath "[$(Get-Date)] Drive $driveLetter is $mediaType. Starting defrag."
    try {
        $output = & defrag.exe "$driveLetter`:" /V 2>&1
        Add-Content $logPath $output
        Add-Content $logPath "[$(Get-Date)] Completed defrag on drive $driveLetter."
    } catch {
        Add-Content $logPath "[$(Get-Date)] ERROR: Defrag failed. $_"
    }
} else {
    Add-Content $logPath "[$(Get-Date)] Drive $driveLetter is SSD. Skipping defrag."
}
