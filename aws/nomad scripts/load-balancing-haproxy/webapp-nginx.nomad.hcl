job "webapp-nginx" {
  datacenters = ["dc1"]
  type        = "service"

  group "nginx" {
    count = 1

    task "nginx" {
      driver = "docker"

      config {
        image        = "nginx:alpine"
        network_mode = "host"
      }

      resources {
        cpu    = 100
        memory = 128
      }

      service {
        name = "nginx"
        tags = ["urlprefix-/"]

        check {
          name          = "tcp"
          type          = "tcp"
          port          = 80
          address_mode  = "driver"
          interval      = "10s"
          timeout       = "2s"
        }
      }
    }
  }
}
