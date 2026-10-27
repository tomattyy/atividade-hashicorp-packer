packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image = "ubuntu:jammy"
  commit = true
}

build {
  sources = ["source.docker.ubuntu"]

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTENMD=noninteractive"]
    inline = [
      "apt-get update",
      "apt-get install -y nodejs npm"
    ]
  }

  provisioner "shell" {
    inline = ["mkdir -p /app"]
  }
  
  provisioner "shell" {
    inline = ["cd /app && npm install"]
  }

  post-processor "docker-tag" {
    repository = "ambiente-node"
    tags = ["v1"]
  }
}