provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Projeto = "k8s-terraform-ansible"
      Aluno   = var.aluno
    }
  }
}
