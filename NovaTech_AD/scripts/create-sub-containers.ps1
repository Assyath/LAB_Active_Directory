$base = "DC=novatech,DC=local"
$ouList = @("Direction", "Infra_Reseaux", "Developpement", "Support", "RH_Admin")
$subContainers = @("Users", "Computers", "Groups")

foreach ($ou in $ouList) {
    $targetOUDN = "OU=$ou,OU=Novatech,$base"
    foreach ($sub in $subContainers) {
        New-ADOrganizationalUnit -Name $sub -Path $targetOUDN
    }
}
