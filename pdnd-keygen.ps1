<#
.SYNOPSIS
	Generate PDND RSA keys
.DESCRIPTION
	This PowerShell script generates PEM, PUB and PRIV keys suitables for PDND authentication.
.EXAMPLE
	PS> ./pdnd-keygen <keyname>
.LINK
	https://github.com/defkon1/PDND-keygen
.NOTES
	Author: Alessio Marinelli | License: MIT
#>

param([string]$KeyName = "pdnd-key")

try {
    if ($IsLinux) {
        throw "Can't run on Linux"
    }
    else {
        $StopWatch = [system.diagnostics.stopwatch]::startNew()

        & openssl genrsa -out $($KeyName + ".rsa.pem") 2048
        if ($lastExitCode -ne "0") { 
            throw "Error generating PEM - make sure openssl is installed and available" 
        }
        else {
            "✔️ PEM generated"
        }

        & openssl rsa -in $($KeyName + ".rsa.pem") -pubout -out $($KeyName + ".rsa.pub")
        if ($lastExitCode -ne "0") { 
            throw "Error generating PUB - make sure openssl is installed and available" 
        }
        else {
            "✔️ PUB generated"
        }

        & openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in $($KeyName + ".rsa.pem") -out $($KeyName + ".rsa.priv")
        if ($lastExitCode -ne "0") { 
            throw "Error generating PRIV - make sure openssl is installed and available" 
        }
        else {
            "✔️ PRIV generated"
        }
    }

    [int]$Elapsed = $StopWatch.Elapsed.TotalSeconds
    "✔️ Keys $KeyName successfully generated in $Elapsed sec"
    
    exit 0 # success
}
catch {
    "⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
    exit 1
}
