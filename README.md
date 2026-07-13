[README.md](https://github.com/user-attachments/files/29986003/README.md)
# LAB\_Active\_Directory: Déploiement Active Directory en environnement d'entreprise

#  Présentation du projet

Ce dépôt documente le déploiement complet d'une infrastructure **Active Directory** pour une entreprise fictive, **NovaTech Solutions**, société de services informatiques basée à Cotonou, Bénin.

Le projet a été réalisé dans un environnement virtualisé (VirtualBox) en partant d'un cahier des charges réel, sans suivre de tutoriel pas à pas, comme on le ferait en conditions professionnelles.

 Environnement technique

| Composant | Détail |
| :---- | :---- |
| Hyperviseur | VirtualBox |
| Contrôleur de domaine | Windows Server 2019 |
| Postes clients | Windows Server 2019 |
| Domaine | novatech.local |
| Utilisateurs | 31 comptes |
| Départements | 5 (Direction, Infra & Réseaux, Développement, Support, RH & Admin) |

 Ce qui a été implémenté

- Déploiement du DC et promotion via PowerShell  
- Arborescence AD : OUs, sous-conteneurs (Users, Groups, Computers)  
- 31 comptes utilisateurs créés depuis fichiers CSV (script automatisé)  
- 5 groupes de sécurité avec affectation automatique  
- Dossiers partagés avec permissions NTFS différenciées par département  
- 8 GPOs configurées : restrictions USB, audit, verrouillage, fond d'écran, délégations  
- Délégations d'administration pour les RH et l'équipe Infra  
- Configuration DHCP intégrée au DC  
- Jonction de 2 postes clients au domaine et tests de connexion utilisateurs

 Structure du dépôt  
NovaTech-AD-Lab/

├── scripts/

│   ├── 01-create-ous.ps1        \# Création de l'arborescence

│   ├── 02-create-sub-containers.ps1     \# Création des sous-conteneurs des OUs

│   ├── 03-create-groups.ps1     \# Création des groupes de sécurité

│   ├── 04-create-users.ps1      \# Création des utilisateurs depuis CSV

│   └── csv/                    \# Fichiers CSV par département

│       ├── direction.csv

│       ├── infra.csv

│       ├── dev.csv

│       ├── support.csv

│       └── rh.csv

├── docs/

│   ├── cahier-des-charges.pdf   \# Spécifications complètes du projet

│   ├── Documentation_Scenario.pdf

└── screenshots/                 \# Captures d'écran des validations

    ├── arborescence-AD.png

    ├── gpo.png

    ├── gpresult-computer.png

    ├── gpresult-user.png

    └── delegation-rh-gpmc.png

Scénarios réels documentés

| Scénario | Description | Statut |
| :---- | :---- | :---- |
| A — Onboarding | Arrivée d'un nouvel employé : création de compte, affectation groupe, vérification GPOs et accès partages | Résolu |
| B — Offboarding | Départ d'une collaboratrice : désactivation, retrait des groupes, archivage des données | Résolu |
| C — Audit RH | Validation des délégations : réinitialisation de mot de passe autonome \+ restriction console GPMC | Résolu |

**Difficultés rencontrées et solutions**  
**Encodage UTF-8 sur les fichiers CSV** Les prénoms accentués généraient des caractères corrompus à l'import PowerShell. → Solution : sauvegarde des CSV en UTF-8 with BOM \+ paramètre `-Encoding utf8` sur `Import-Csv`

**Security Filtering sur une GPO Computer** Un filtre basé sur des utilisateurs ne s'applique pas à une GPO en Computer Configuration : le PC démarre sans contexte utilisateur, le filtre est ignoré. → Solution : migration de la GPO en User Configuration avec Security Filtering adapté au groupe d'exception

**Distinction GPO Utilisateur vs Ordinateur** Identifier si une restriction doit suivre la personne ou s'appliquer au poste; la question se pose différemment selon le cas d'usage (ex : blocage USB sur le poste vs restriction bureau pour l'utilisateur). → Solution : "est-ce que cette règle concerne le poste ou la personne ?" 

**Auteure**  
**Safirath BAKARY** Diplômée en Sécurité Informatique (IFRI, Université d'Abomey-Calavi, Bénin) Certification Google IT Support En recherche de stage en infrastructure et réseaux à Cotonou  
[**LinkedIn**](http://linkedin.com/in/safirath-bakary-89844a208) 
