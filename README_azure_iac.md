# ☁️ Azure Infrastructure as Code — AKS + MySQL + VM

Déploiement automatisé d'une infrastructure Azure complète via **Terraform** et **Azure DevOps**, incluant un cluster Kubernetes (AKS), une base de données MySQL Flexible Server, et une machine virtuelle — le tout dans un réseau virtuel sécurisé.

---

## 🏗️ Architecture

```
USER → Azure DevOps Repo
            │
            ├── 🚀 Storage Creation   → Crée le Storage Account pour le Terraform State
            ├── 🚀 Infra Deploy       → Déploie toute l'infrastructure Azure
            └── 🔥 Destroy Infra      → Détruit l'infrastructure complète
                        │
                        ▼
            Resource Group
                        │
                        ▼
            Virtual Network (172.18.0.0/16)
            ├── MySQL Subnet    (172.18.2.0/24) — NSG
            │       └── MySQL Flexible Server
            ├── AKS Subnet      (172.18.1.0/24) — NSG
            │       └── Node AKS
            │               ├── WordPress
            │               ├── Joomla
            │               ├── Anchor CMS
            │               ├── Grafana Loki
            │               └── ...
            └── VM Subnet       (172.18.3.0/24) — NSG
                    └── Virtual Machine
                                        │
                                        ▼
                            Storage Account (TF STATE)
```

---

## ✨ Composants déployés

| Composant | Description |
|-----------|-------------|
| **Resource Group** | Conteneur logique de toutes les ressources Azure |
| **Virtual Network** | VNet `172.18.0.0/16` segmenté en 3 sous-réseaux |
| **NSG** | Network Security Groups sur chaque subnet |
| **MySQL Flexible Server** | Base de données managée sur subnet dédié |
| **AKS Cluster** | Cluster Kubernetes avec node pool sur AKS Subnet |
| **Virtual Machine** | VM Linux sur subnet dédié |
| **Storage Account (TF State)** | Backend distant pour l'état Terraform |

### Applications déployées sur AKS
- **WordPress** — CMS
- **Joomla** — CMS
- **Anchor CMS** — CMS léger
- **Grafana Loki** — Stack de logs et monitoring

---

## 🔄 Pipelines Azure DevOps

### 1. `Storage Creation`
Crée le **Storage Account Azure** utilisé comme backend distant pour stocker le fichier `terraform.tfstate`. À exécuter **en premier**, une seule fois.

### 2. `Infra Deploy`
Lance `terraform init`, `terraform plan` et `terraform apply` pour déployer l'ensemble de l'infrastructure dans Azure.

### 3. `Destroy Infra`
Lance `terraform destroy` pour supprimer proprement toutes les ressources provisionnées.

---

## 📁 Structure du projet (suggérée)

```
azure-iac/
├── pipelines/
│   ├── storage-creation.yml   # Pipeline création du backend TF
│   ├── infra-deploy.yml       # Pipeline déploiement infra
│   └── destroy-infra.yml      # Pipeline destruction infra
├── terraform/
│   ├── main.tf                # Ressources principales
│   ├── variables.tf           # Déclaration des variables
│   ├── outputs.tf             # Sorties Terraform
│   ├── providers.tf           # Configuration provider Azure
│   ├── backend.tf             # Configuration backend remote state
│   └── modules/
│       ├── network/           # VNet, Subnets, NSG
│       ├── mysql/             # MySQL Flexible Server
│       ├── aks/               # Cluster AKS
│       └── vm/                # Virtual Machine
└── README.md
```

---

## 🚀 Déploiement

### Prérequis

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3
- [Azure CLI](https://learn.microsoft.com/fr-fr/cli/azure/install-azure-cli) installé et configuré
- Un abonnement Azure actif
- Un projet Azure DevOps avec les pipelines configurés

### 1. Connexion Azure

```bash
az login
az account set --subscription "<votre-subscription-id>"
```

### 2. Créer le backend Terraform (Storage Account)

Exécutez le pipeline **Storage Creation** dans Azure DevOps, ou manuellement :

```bash
az group create --name rg-tfstate --location francecentral
az storage account create --name satfstate<suffix> --resource-group rg-tfstate --sku Standard_LRS
az storage container create --name tfstate --account-name satfstate<suffix>
```

### 3. Initialiser Terraform

```bash
cd terraform/
terraform init
```

### 4. Planifier le déploiement

```bash
terraform plan -out=tfplan
```

### 5. Appliquer

```bash
terraform apply tfplan
```

### 6. Détruire l'infrastructure

```bash
terraform destroy
```

---

## 🔒 Sécurité

- Chaque subnet est protégé par un **NSG** (Network Security Group) avec règles de trafic entrante/sortante
- Le MySQL Flexible Server est isolé sur son propre subnet, **sans IP publique**
- Les secrets (mots de passe, clés) doivent être stockés dans **Azure Key Vault** ou en tant que **variables secrètes Azure DevOps**

---

## 📄 Licence

Projet privé — Tous droits réservés.
