locals {
  worker_lines = [
    for i, ip in aws_instance.worker[*].public_ip :
    "k8s-worker-${i + 1} ansible_host=${ip}"
  ]
}

resource "local_file" "ansible_inventory" {
  filename        = "${path.module}/../ansible/inventory.ini"
  file_permission = "0644"

  content = templatefile("${path.module}/inventory.tftpl", {
    control_plane_ip = aws_instance.control_plane.public_ip
    workers          = join("\n", local.worker_lines)
    ssh_key_path     = var.private_key_path
  })
}
