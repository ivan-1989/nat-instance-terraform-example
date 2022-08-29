
resource "yandex_vpc_security_group" "sg-inet-acc" {
  name        = "sg-inet-acc"
  description = "defines which environments can access NAT-Instance for Internet access"
  network_id  = yandex_vpc_network.vpc-infra.id


  ingress {
    protocol       = "ICMP"
    description    = "Allow pings from all privarte etworks for tshoot"
    v4_cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    protocol       = "TCP"
    description    = "K8S security group can only access Inet on safe port"
    security_group_id  = yandex_vpc_security_group.sg-k8s.id
    port      = 443
  }

  ingress {
    protocol       = "TCP"
    description    = "K8S security group can only access Inet on safe port"
    security_group_id  = yandex_vpc_security_group.sg-k8s.id
    port      = 80
  }


  egress {
    protocol       = "ANY"
    description    = "NAT-INSTANCE can access private networks"
    v4_cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    protocol       = "TCP"
    description    = "NAT-INSTANCE can forward traaffic towards container registry, api and yandex storage"
    v4_cidr_blocks = ["84.201.171.239/32", "213.180.193.243/32", "84.201.181.26"]
  }
}

resource "yandex_vpc_security_group" sg-k8s {
  name        = "sg-k8s-demo"
  description = "this is sample security group that is applied to cluster nodes"
  network_id  = yandex_vpc_network.vpc-infra.id


  ingress {
    protocol       = "ANY"
    description    = "for demo purposes we allow any traffic, in real scenario this will have actual k8s rules"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    protocol       = "ANY"
    description    = "for demo purposes we allow any traffic, in real scenario this will have actual k8s rules"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
