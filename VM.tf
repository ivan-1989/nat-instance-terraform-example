data "yandex_compute_image" "nat_instance" {
  family = "nat-instance-ubuntu"
}

data "yandex_compute_image" "vm_img" {
  family = "ubuntu-1804-lts"
}


resource "yandex_compute_instance" "nat-instance" {
  zone        = "ru-central1-a"
  name        = "nat-instance"
  hostname    = "nat-instance"
  platform_id = "standard-v3"
  resources {
    cores  = 4
    memory = 8
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat_instance.id
      type     = "network-ssd"
      size     = 26
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.public-subnet.id
    ip_address = "10.0.0.5"
    nat = true
    security_group_ids = [yandex_vpc_security_group.sg-inet-acc.id]
}

metadata = {
  user-data = file("cloud_config_def.yaml")
  serial-port-enable = 1
}
}

resource "yandex_compute_instance" "vm-k8s" {
  zone        = "ru-central1-a"
  name        = "vm-k8s"
  hostname    = "vm-k8s"
  platform_id = "standard-v2"
  resources {
    cores  = 2
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.vm_img.id
      type     = "network-ssd"
      size     = 26
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.k8s-subnet.id
    nat = false
    security_group_ids = [yandex_vpc_security_group.sg-k8s.id]
}

metadata = {
  user-data = file("cloud_config_def.yaml")
  serial-port-enable = 1
}
}

