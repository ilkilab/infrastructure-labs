resource "scaleway_instance_ip" "public_ip" {
  count = 1
}

resource "scaleway_instance_security_group" "sg" {
  inbound_default_policy  = "accept"
  outbound_default_policy = "accept"
}

resource "scaleway_vpc_private_network" "network" {
  name = "${var.name}-private_network"
}

resource "scaleway_instance_server" "master" {
  name  = "${var.name}-master"
  type  = "DEV1-S"
  image = "ubuntu_focal"
  ip_id = scaleway_instance_ip.public_ip[2].id
  tags  = ["CKA", "LABS", "PIERRE"]
  user_data = {
    docker     = "installed"
    cloud-init = file("setup-master.sh")
  }
  private_network {
    pn_id = scaleway_vpc_private_network.network.id
  }
  security_group_id = scaleway_instance_security_group.sg.id
}

output "public_ip_master" {
  value = scaleway_instance_server.master.public_ip
}
}
output "private_ip_master" {
  value = scaleway_instance_server.master.private_ip
}

