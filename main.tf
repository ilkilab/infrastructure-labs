resource "scaleway_instance_ip" "public_ip" {
    count = 6
}

resource "scaleway_instance_server" "web" {
  count = 6
  type = "DEV1-S"
  image = "ubuntu_focal"
  ip_id = scaleway_instance_ip.public_ip[count.index].id
}