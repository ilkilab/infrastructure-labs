resource "scaleway_instance_ip" "public_ip" {
  
}

resource "scaleway_instance_security_group" "sg" {
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action = "accept"
    port   = 22
  }

  inbound_rule {
    action = "accept"
    port   = 80
  }

  inbound_rule {
    action = "accept"
    port   = 443
  }
}

resource "scaleway_vpc_private_network" "network" {
  name = "${var.name}-private_network"
}

resource "scaleway_instance_server" "website" {
  name  = "${var.name}-web"
  type  = "DEV1-S"
  image = "ubuntu_focal"
  ip_id = scaleway_instance_ip.public_ip.id
  tags  = ["DEMO", "LABS", "PIERRE"]
  user_data = {
    docker     = "installed"
    cloud-init = file("setup-master.sh")
  }
  private_network {
    pn_id = scaleway_vpc_private_network.network.id
  }
  security_group_id = scaleway_instance_security_group.sg.id
}

output "public_ip_website" {
  value = scaleway_instance_server.website.public_ip
}

output "content_website" {
  value = var.content
}
