provider "matchbox" {
  endpoint    = "matchbox.cluster.internal:8081"
  client_cert = file("~/.matchbox/client.crt")
  client_key  = file("~/.matchbox/client.key")
  ca          = file("~/.matchbox/ca.crt")
}

provider "ct" {}

terraform {
  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "0.11.0"
    }
    matchbox = {
      source = "poseidon/matchbox"
      version = "0.5.2"
    }
  }
}

module "mercury" {
  source = "git::https://github.com/poseidon/typhoon//bare-metal/flatcar-linux/kubernetes?ref=v1.25.1"

  # bare-metal
  cluster_name            = "mercury"
  matchbox_http_endpoint  = "http://matchbox.cluster.internal:8080"
  os_channel              = "flatcar-stable"
  os_version              = "3227.2.2"

  # configuration
  k8s_domain_name    = "K8S-M-9C2KZG2.cluster.internal"
  ssh_authorized_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJhfY9laR5hqMQ9d8gFUCqb6ru6LCmXuMxw60eSZAa8 jonas@K8S-9C1KZG2"

  # installation
  cached_install          = true  

  # machines
  controllers = [{
    name   = "K8S-M-9C2KZG2"
    mac    = "48:4d:7e:d3:72:a0"
    domain = "K8S-M-9C2KZG2.cluster.internal"
  }]
  workers = [
    {
      name   = "K8S-G-9C3CZG2",
      mac    = "48:4d:7e:d3:66:70"
      domain = "K8S-G-9C3CZG2.cluster.internal"
    },
    {
      name   = "K8S-G-9C2LZG2",
      mac    = "48:4d:7e:d3:6b:55"
      domain = "K8S-G-9C2LZG2.cluster.internal"
    },
    {
      name   = "K8S-G-9C1JZG2",
      mac    = "48:4d:7e:d3:71:aa"
      domain = "K8S-G-9C1JZG2.cluster.internal"
    },
    {
      name   = "K8S-G-9C0DZG2",
      mac    = "48:4d:7e:d3:66:9c"
      domain = "K8S-G-9C0DZG2.cluster.internal"
    },
    {
      name   = "K8S-G-9BTDZG2",
      mac    = "48:4d:7e:d3:6f:0c"
      domain = "K8S-G-9BTDZG2.cluster.internal"
    },
    {
      name   = "K8S-G-9C1CZG2",
      mac    = "48:4d:7e:d3:71:82"
      domain = "K8S-G-9C1CZG2.cluster.internal"
    },
    {
      name   = "K8S-G-9BYFZG2",
      mac    = "48:4d:7e:d3:74:91"
      domain = "K8S-G-9BYFZG2.cluster.internal"
    },
    {
      name   = "K8S-G-9C0KZG2",
      mac    = "48:4d:7e:d3:74:a7"
      domain = "K8S-G-9C0KZG2.cluster.internal"
    },
    {
      name   = "K8S-G-9BVBZG2",
      mac    = "48:4d:7e:d3:74:47"
      domain = "K8S-G-9BVBZG2.cluster.internal"
    }
  ]
}

resource "local_file" "kubeconfig-mercury" {
  content  = module.mercury.kubeconfig-admin
  filename = "/home/jonas/.kube/configs/mercury-config"
}