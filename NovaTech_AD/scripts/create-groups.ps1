
$DomainDN = (Get-ADRootDSE).defaultNamingContext
$ParentPath = "OU=novatech,$DomainDN"

# Cartographie des groupes à créer par OU
# Format : "Nom de la sous-OU" = @("Nom_Groupe_1")
$GroupMapping = @{
    "Direction"              = @("GRP-Direction")
    "Infrastructure Reseaux" = @("GRP-Infra")
    "Support"                = @("GRP-Support")
    "RH_Admin"               = @("GRP-RH")
    "Developpement"          = @("GRP-Dev")
}

# création automatique
foreach ($OU in $GroupMapping.Keys) {
    # Détermination du chemin exact de la sous-OU
    $TargetOUPath = "OU=$OU,$ParentPath"
    
    # Vérification que l'OU cible existe bien
    if (Get-ADOrganizationalUnit -Filter * -SearchBase $TargetOUPath -ErrorAction SilentlyContinue) {
        
        foreach ($GroupName in $GroupMapping[$OU]) {
            # Vérification de l'existence du groupe
            if (-not (Get-ADGroup -Filter "Name -eq '$GroupName'")) {
                
                # Création du groupe de sécurité global
                New-ADGroup -Name $GroupName `
                            -SamAccountName $GroupName `
                            -GroupScope Global `
                            -GroupCategory Security `
                            -Path $TargetOUPath
                
                Write-Host "✓ Groupe '$GroupName' créé avec succès dans l'OU [$OU]." -ForegroundColor Green
            } else {
                Write-Host "i Le groupe '$GroupName' existe déjà." -ForegroundColor Yellow
            }
        }
    } else {
        Write-Warning " L'OU cible '$TargetOUPath' n'existe pas. Impossible d'y créer les groupes."
    }
}

Write-Host "`nDéploiement des groupes de sécurité terminé !" -ForegroundColor Cyan

