data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "k8s" {
  key_name   = "k8s-lab-key-${var.aluno}"
  public_key = file(pathexpand(var.public_key_path))
}

resource "aws_instance" "control_plane" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.control_plane.id
  vpc_security_group_ids = [aws_security_group.k8s.id]
  key_name               = aws_key_pair.k8s.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "k8s-control-plane-${var.aluno}"
  }
}

resource "aws_instance" "worker" {
  count                  = var.worker_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.workers.id
  vpc_security_group_ids = [aws_security_group.k8s.id]
  key_name               = aws_key_pair.k8s.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "k8s-worker-${count.index + 1}-${var.aluno}"
  }
}