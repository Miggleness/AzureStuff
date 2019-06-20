function Login {
    param (
        [System.Boolean] $confirmIfLoggedIn
    )

    $context = Get-AzContext
    if ($null -eq $context) {
        $r = Connect-AzAccount
        $context = Get-AzContext
    }
    elseif ($confirmIfLoggedIn) {
        $keyOptions = 'Y', 'y', 'N', 'n'
        $ReloginKeyPress = Write-Host -Object ('The key that was pressed was: {0}' -f [System.Console]::ReadKey().Key.ToString());
        # while($keyOptions -notcontains $ReloginKeyPress.Character)
        # {
        #     $ReloginKeyPress = Write-Host -Object ('The key that was pressed was: {0}' -f [System.Console]::ReadKey().Key.ToString());
        # }

        if ($ReloginKeyPress.Character -eq 'Y' -or $ReloginKeyPress.Character -eq 'y') {
            $context = Login($false)
        }
    }
    # return context
    $context
}

$context = Login($true)
Write-Output $context