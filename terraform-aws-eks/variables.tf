variable "aws_region" {
  description = "Région AWS pour le déploiement"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
  default     = "esigelec-eks-cluster"
}

variable "kubernetes_version" {
  description = "Version de Kubernetes"
  type        = string
  default     = "1.28"
}

variable "desired_nodes" {
  description = "Nombre de nodes souhaité"
  type        = number
  default     = 3
}

variable "min_nodes" {
  description = "Nombre minimum de nodes"
  type        = number
  default     = 2
}

variable "max_nodes" {
  description = "Nombre maximum de nodes"
  type        = number
  default     = 5
}

variable "instance_types" {
  description = "Types d'instances EC2 pour les nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

