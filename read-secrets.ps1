$TenantId = "319b4d81-6f9c-4751-be36-029f51b0d849"
$ClientId = "275322d7-0485-408e-a1be-0ee271a12b5e"
$ClientSecret = "Vcp8Q~reodCnJV2Bl4pDNolaIwMAhr1JclSpTcMd"
$KeyVaultName = "github-keyvault-kv"
$SecretNamesList = "my-secret,another-secret,nonexisting-secret"

$SecurePassword = ConvertTo-SecureString -String $ClientSecret -AsPlainText -Force
$Credential = New-Object pscredential -ArgumentList $ClientId, $SecurePassword
Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $Credential

$SecretsDictionary = @{}
$SecretNamesList -split ',' | ForEach-Object {
    
    try {
        #$SecretValue = (az keyvault secret show --vault-name $KeyVaultName --name $_ --query value --output tsv)    
        $SecretValue = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $_
        $SecretValueText = ConvertFrom-SecureString -SecureString $SecretValue.SecretValue -AsPlainText
    }
    catch {
        $SecretValueText = $null
    }

    if ($null -ne $SecretValueText)
    {
        $SecretsDictionary.Add($_, $SecretValueText)
    }
}

$SecretsDictionary.Keys | ForEach-Object {
    $Msg = "{0} = {1}" -f $_, $SecretsDictionary[$_]
    $Msg
}
