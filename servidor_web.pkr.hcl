packer {
  required_plugins {
    docker ={
      version = ">=1.0.8"
      source = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image = "ubuntu:jammy"
  commit = true
  changes = [
    "EXPOSE 80",
    "CMD [\"/usr/sbin/apache2ctl\",\"-D\", ]"
  ]
}

build {
  name = "apache-build"
  sources = ["source.docker.ubuntu"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y apache2"
    ]
  }

  provisioner "file" {
    source = "index.html"
    destination = "/var/www/html/index.html"
  }

  post-processor "docker-tag" {
    repository = "apache-packer"
    tags = ["latest"]
  }
}