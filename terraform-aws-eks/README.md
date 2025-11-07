# Cluster EKS sur AWS avec Terraform

Ce projet Terraform crée un cluster Kubernetes (EKS) sur AWS avec toute l'infrastructure réseau nécessaire.

## Architecture

- **VPC** : 10.0.0.0/16
- **Subnets publics** : 2 subnets dans des AZ différentes
- **Subnets privés** : 2 subnets pour les nodes
- **NAT Gateways** : 2 pour la haute disponibilité
- **EKS Cluster** : Version Kubernetes 1.28
- **Node Group** : 3 nodes t3.medium (min: 2, max: 5)

## Prérequis

1. **AWS CLI** installé et configuré :
   ```bash
   aws configure
   ```

2. **Terraform** installé (version >= 1.0) :
   ```bash
   # Vérifier l'installation
   terraform --version
   ```

3. **kubectl** installé pour interagir avec le cluster

## Configuration

Modifiez les variables dans `variables.tf` ou créez un fichier `terraform.tfvars` :

```hcl
aws_region         = "eu-west-1"
cluster_name       = "esigelec-eks-cluster"
kubernetes_version = "1.28"
desired_nodes      = 3
min_nodes          = 2
max_nodes          = 5
instance_types     = ["t3.medium"]
```

## Déploiement

### 1. Initialiser Terraform
```bash
cd terraform-aws-eks
terraform init
```

### 2. Vérifier le plan
```bash
terraform plan
```

### 3. Déployer l'infrastructure
```bash
terraform apply
```

Tapez `yes` pour confirmer le déploiement.

⏱️ **Temps de création** : environ 15-20 minutes

### 4. Configurer kubectl
Après le déploiement, configurez kubectl pour accéder au cluster :

```bash
aws eks update-kubeconfig --region eu-west-1 --name esigelec-eks-cluster
```

### 5. Vérifier le cluster
```bash
kubectl get nodes
kubectl get pods -A
```

## Déployer votre application hello-world

Une fois le cluster créé, vous pouvez déployer votre application :

```bash
# Adapter le fichier YAML pour ne pas utiliser IBM Cloud Registry
kubectl apply -f ..\labs-docker-k8s\1_IntroKubernetes\hello-world-apply.yaml

# Vérifier le déploiement
kubectl get deployments
kubectl get pods

# Créer un service pour exposer l'application
kubectl expose deployment hello-world --type=LoadBalancer --port=8080
kubectl get services hello-world
```

## Coûts estimés

- **EKS Cluster** : ~$0.10/heure (~$72/mois)
- **3 x t3.medium** : ~$0.0416/heure chacun (~$90/mois pour 3)
- **NAT Gateways** : ~$0.045/heure chacun (~$65/mois pour 2)
- **Total estimé** : ~$227/mois

💡 **Astuce** : N'oubliez pas de détruire l'infrastructure quand vous ne l'utilisez plus !

## Nettoyage

Pour supprimer toute l'infrastructure :

```bash
# Supprimer d'abord les ressources Kubernetes (LoadBalancers, etc.)
kubectl delete service hello-world
kubectl delete deployment hello-world

# Détruire l'infrastructure Terraform
terraform destroy
```

## Troubleshooting

### Problème d'authentification
```bash
# Vérifier les credentials AWS
aws sts get-caller-identity

# Reconfigurer kubectl
aws eks update-kubeconfig --region eu-west-1 --name esigelec-eks-cluster
```

### Nodes non disponibles
```bash
# Vérifier les logs du node group
aws eks describe-nodegroup --cluster-name esigelec-eks-cluster --nodegroup-name esigelec-eks-cluster-node-group
```

## Personnalisation

### Changer la région
Modifiez `aws_region` dans `variables.tf` ou passez via la ligne de commande :
```bash
terraform apply -var="aws_region=us-east-1"
```

### Modifier le nombre de nodes
```bash
terraform apply -var="desired_nodes=5"
```

### Utiliser des instances plus puissantes
```bash
terraform apply -var='instance_types=["t3.large"]'
```

## Sécurité

- Les nodes sont déployés dans des subnets privés
- Accès Internet via NAT Gateways
- Security groups configurés automatiquement
- IAM roles avec principe du moindre privilège

## Ressources créées

- 1 VPC
- 2 Subnets publics
- 2 Subnets privés
- 1 Internet Gateway
- 2 NAT Gateways
- 2 Elastic IPs
- 3 Route tables
- 1 EKS Cluster
- 1 Node Group (3 nodes)
- Security Groups
- IAM Roles et Policies

