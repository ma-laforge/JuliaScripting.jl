#Launch a "JLScript" Julia script
param (
    [Parameter(Mandatory=$true)][string]$scriptfile
)
#TODO: Generalize to pass arguments to script!
$regex ="^#!JLScript "
$cmd_julia = "$PSScriptRoot\julia.exe" #Assume this file is copied in Julia's `bin\` directory.
$scriptfile = Resolve-Path $scriptfile #Clean up

function Raise-InvalidScriptFile {
	Write-Error "`nNot a valid julia script:`n`t$scriptfile"
	exit 1
}

[System.IO.StreamReader]$io = [System.IO.File]::Open($scriptfile, [System.IO.FileMode]::Open)
$line = ""
if (-not $io.EndOfStream){$line = $io.ReadLine()} #Only care about first line
$io.Close() 
Write-Output $line
if ($line -notmatch $regex){
	Raise-InvalidScriptFile
}

#Launch julia
$env:JULIA_LOAD_PATH="@;@stdlib" #Ensure we have a clean environment stack
$scriptfile_dir = Split-Path -Path $scriptfile
$jlargs = $line.Substring($regex.Length-1) #Account for "^" character
$jlargs = "$jlargs -- $scriptfile"
Start-Process -FilePath $cmd_julia -ArgumentList $jlargs -WorkingDirectory $scriptfile_dir