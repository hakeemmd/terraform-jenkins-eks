#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnets
  public_subnets          = var.public_subnets
  

  enable_dns_hostnames = true
enable_nat_gateway = true
tags ={
    "kubernetes.io/cluster/my-eks-cluster"="shared"
}
public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster"="shared"
    "kubernetes.io/role/elb"  =1
}
  private_subnet_tags ={
    "kubernetes.io/cluster/my-eks-cluster"="shared"
    "kubernetes.io/role/elb"  =1
  }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.29"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  
# EKS Managed Node Group(s)
  
  eks_managed_node_groups = {
    Node  ={
        min_size = 1
        max_size = 3
        desired_size = 2
        instance_type = ["t2-small"]
    }
  }

  

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}