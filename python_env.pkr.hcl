packer {
  required_plugins {
    docker = {
      version = ">= 1.0.8"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image = "ubunty:jammy"
  commit = true
  changes = {
    "WORKDIR" = "/app"
  }
}

build {
  sources = ["source.docker.ubuntu"]

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    inline = [
      "apt-get update",
      "apt-get install -y python3 python3-pip",
      "mkdir -p /app"
      "python3 -m pip install flask"
    ]
  }

  post-processor "docker-tag" {
    repository = "ambiente-dev-python"
    tags = ["v1"]
  }
}