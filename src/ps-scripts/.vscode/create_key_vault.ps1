# login
#Connect-AzAccount

# vars
$rgName = "mig-test-resource-group"
$location = "Southeast Asia"
$vaultName = "mig-test-vault-name"
$secretName = "mysecret"
$secretValue = ConvertTo-SecureString -String "asdf" -AsPlainText -Force

# create resource group
$rg = Get-AzResourceGroup -Name $rgName
if (!$rg) {
    $rg = New-AzResourceGroup -Name $rgName -Location $location 
}

# create vault if it doesn't exist
$vault = Get-AzKeyVault -VaultName $vaultName -ResourceGroupName $rg.ResourceGroupName
if (!$vault) {
    New-AzKeyVault -Name $vaultName `
        -ResourceGroupName $rg.ResourceGroupName `
        -Location $location
}

# add a key to vault
$secret = Get-AzKeyVaultSecret -VaultName $vaultName -Name $secretName
if (!secret) {
    Set-AzKeyVaultSecret -VaultName $vaultName `
        -Name $secretName `
        -SecretValue $secretValue
}

## clear
Remove-AzKeyVault -VaultName $vaultName -ResourceGroupName $rgName -Force
Remove-AzResourceGroup -Name $rgName -Force

