resource "yandex_vpc_network" "vpc-infra" {
  name = "vpc-infra-k8s"
}

resource "yandex_vpc_route_table" "rt-inet" {
  name = "rt-inet"
  network_id = yandex_vpc_network.vpc-infra.id

  static_route {
    destination_prefix = "84.201.171.239/32"
    next_hop_address   = "10.0.0.5"
  }
    static_route {
    destination_prefix = "213.180.193.243/32"
    next_hop_address   = "10.0.0.5"
  }
    static_route {
    destination_prefix = "84.201.181.26/32"
    next_hop_address   = "10.0.0.5"
  }
}

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-infra.id
  v4_cidr_blocks = ["10.0.0.0/24"]

}

resource "yandex_vpc_subnet" "k8s-subnet" {
  name           = "subnet for k8s nodes"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc-infra.id
  v4_cidr_blocks = ["10.50.0.0/24"]
  route_table_id = yandex_vpc_route_table.rt-inet.id
}
