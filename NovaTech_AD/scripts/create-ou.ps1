# 1. Définition du domaine actuel 
$DomainDN = (Get-ADRootDSE).defaultNamingContext

# 2. Nom de l'OU parente
$ParentOUName = "novatech"
$ParentOUDN = "OU=$ParentOUName,$DomainDN"

# 3. Liste des 5 sous-OU à créer
$SubOUs = @("Direction", "Infra_Reseaux", "Support", "RH_Admin", "Developpement")

# 4. Création de l'OU Parente "novatech"
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ParentOUName'")) {
    New-ADOrganizationalUnit -Name $ParentOUName `
                             -Path $DomainDN `
                             -ProtectedFromAccidentalDeletion $true
    Write-Host "✓ OU Parente '$ParentOUName' créée avec succès." -ForegroundColor Green
} else {
    Write-Host "i L'OU Parente '$ParentOUName' existe déjà." -ForegroundColor Yellow
}

# 5. Création automatique des 5 sous-OU
foreach ($OU in $SubOUs) {
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$OU'" -SearchBase $ParentOUDN -SearchScope OneLevel)) {
        New-ADOrganizationalUnit -Name $OU `
                                 -Path $ParentOUDN `
                                 -ProtectedFromAccidentalDeletion $true
        Write-Host "  └─ ✓ Sous-OU '$OU' créée." -ForegroundColor Green
    } else {
        Write-Host "  └─ i La sous-OU '$OU' existe déjà." -ForegroundColor Yellow
    }
}

Write-Host "`nStructure Active Directory finalisée !" -ForegroundColor Cyan

