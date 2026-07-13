$base = "DC=novatech,DC=local"
$csvPath = "$home\Desktop\dev.csv"

# Mot de passe exigé par votre document
$defaultPassword = ConvertTo-SecureString "NovaTech@2025!" -AsPlainText -Force

# Lecture du fichier CSV
$users = Import-Csv -Path $csvPath -Delimiter "," -Encoding utf8

foreach ($user in $users) {
    # Emplacement ciblé : sous-OU Users de l'OU Developpement
    $targetOU = "OU=Users,OU=Developpement,OU=Novatech,$base"
    $targetGroup = "CN=$($user.Groupe),OU=Groups,OU=Developpement,OU=Novatech,$base"
    
    # Paramètres de création conformes à votre convention de nommage
    $userParams = @{
        Name                  = "$($user.Prenom) $($user.Nom)"
        GivenName             = $user.Prenom
        Surname               = $user.Nom
        SamAccountName        = $user.Identifiant
        UserPrincipalName     = "$($user.Identifiant)@novatech.local"
        Path                  = $targetOU
        AccountPassword       = $defaultPassword
        ChangePasswordAtLogon = $true
        Enabled               = $true
    }
    
    # Création de l'utilisateur
    New-ADUser @userParams
    Write-Host "Utilisateur créé : $($user.Identifiant)" -ForegroundColor Green
    
    # Ajout automatique au groupe GRP-Dev
    Add-ADGroupMember -Identity $targetGroup -Members $user.Identifiant
    Write-Host "  -> Ajouté au groupe : $($user.Groupe)" -ForegroundColor Cyan
}