resource "scaleway_instance_ip" "public_ip" {
    count = 3
}

resource "scaleway_instance_security_group" "sg" {
  inbound_default_policy = "accept"
  outbound_default_policy = "accept"
}

resource "scaleway_instance_server" "server" {
  count = 3
  name = "${var.name}-${count.index}"
  type = "DEV1-S"
  image = "ubuntu_focal"
  ip_id = scaleway_instance_ip.public_ip[count.index].id
  tags = [ "CKA", "LABS", "PIERRE" ]
  user_data = {
    docker        = "installed"
    cloud-init = file("docker.sh")
  }
  security_group_id= scaleway_instance_security_group.sg.id
}

output "ip_master" {
  value = scaleway_instance_server.server[0].public_ip
}
output "ip_worker1" {
  value = scaleway_instance_server.server[1].public_ip
}
output "ip_worker2" {
  value = scaleway_instance_server.server[2].public_ip
}