function get-licensestorenew {
    param(
        $CustomFieldName, 
        $WithinXDays
    )

    
    #region debug setup
    if ([Environment]::UserInteractive -eq $true -or $APDebugMode) {
        if (-not (Get-Module IgapCore)) {
            try {
                #this part requires that the workflow engine is installed on the machine running this script
                $wfeLocation = (Get-WmiObject win32_service | where-object { $_.Name -eq "Snow Automation Platform Workflow Engine" } | Select-Object PathName).PathName
                $wfeDirectory = $wfeLocation.Substring(1, $wfeLocation.LastIndexOf('\') - 1) 
                $apdirectory = $wfeDirectory.Substring(0, $wfeDirectory.LastIndexOf('\'))
                $apdirectory
                Import-Module "$apdirectory\CoreScripts\IgapCore.psm1"
            }
            catch {
                #if the workflow engine is not installed on the machine running this script, update the path below
                Import-Module 'C:\Program Files\Snow Software\Snow Automation Platform\CoreScripts\IgapCore.psm1'
            }
            
        }
        if (Get-Module IgapCore) {
            if (Test-Path -Path Function:Write-Host) { remove-item -Path Function:Write-Host }
            if (Test-Path -Path Function:Write-Verbose) { remove-item -Path Function:Write-Verbose }
            if (Test-Path -Path Function:Write-Warning) { remove-item -Path Function:Write-Warning }
            if (Test-Path -Path Function:Write-Error) { remove-item -Path Function:Write-Error }
        }
    }
    #endregion
    
    #SLMHelper is available at https://github.com/SnowSoftware/slm-module-SLMHelper
    if (-not (Get-Module SLMHelper)) {
        Try {
            Import-Module SLMHelper -ErrorAction Stop
        }
        catch {
            Write-Error "Failed to import SLMHelper module."
            return
        }
    }
    
    #region SLM Settings
    $SLMApiAccountName = Get-APSetting "SLMApiAccountName" -Force
    $SLMUri = Get-APSetting "SLMUri" -Force
    $SLMCustomerId = Get-APSetting "SLMCustomerId"
    $SLMUserAccount = Get-ServiceAccount -Name $SLMApiAccountName
    
    $securePassword = ConvertTo-SecureString $($SLMUserAccount.Password) -AsPlainText -Force
    $SLMApiCredentials = New-Object Management.Automation.PSCredential ($($SLMUserAccount.AccountName), $securePassword)
    #endregion
    
    $SLMApiEndpointConfiguration = New-SLMApiEndpointConfiguration -SLMUri $SLMUri -SLMCustomerId $SLMCustomerId -SLMApiCredentials $SLMApiCredentials -CleanupBody
    
    $RenewalCustomField = Get-SLMCustomFieldDefinitions -SLMApiEndpointConfiguration $SLMApiEndpointConfiguration -Name $CustomFieldName -ObjectType License -ReturnAsSLMObject


    $licensecustomfields = Get-SLMCustomFieldValues -SLMApiEndpointConfiguration $SLMApiEndpointConfiguration -ObjectType License -CustomFieldId $RenewalCustomField.CustomFieldId -ReturnAsSLMObject

    $LicenseIDToRenewWithinXDays = $licensecustomfields | Where-Object { [datetime]$_.Value -le $(get-date).AddDays($WithinXDays) } | Select-Object -ExpandProperty ElementId

    $LicensesToRenew = @()

    foreach ($LicenseID in $LicenseIDToRenewWithinXDays) {

        $LicenseObject = Get-SLMLicenseDetails -SLMApiEndpointConfiguration $SLMApiEndpointConfiguration -Id $LicenseID -ReturnAsSLMObject

        $RenewalDate = $LicenseObject.CustomFields | Where-Object { $_.Name -eq $CustomFieldName } | Select-Object -ExpandProperty Value

        $LicenseObject | Add-Member -MemberType NoteProperty -Name "RenewalDate" -Value $RenewalDate -Force

        $LicensesToRenew += $LicenseObject

    }

    return $LicensesToRenew

}

# get-licensestorenew -CustomFieldName 'Renewal Date' -WithinXDays 999