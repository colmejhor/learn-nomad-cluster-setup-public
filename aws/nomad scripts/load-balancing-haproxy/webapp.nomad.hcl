job "demo-webapp" {
  datacenters = ["dc1"]
  type        = "service"

  group "demo" {
    count = 3

    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/demo-webapp-lb-guide"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 64

        network {
          port "http" {}
        }
      }

      service {
        name = "demo-webapp"
        port = "http"

        tags = ["urlprefix-/"]

        check {
          type     = "http"
          path     = "/"
          interval = "2s"
          timeout  = "2s"
        }
      }

      env {
        PORT    = "${NOMAD_PORT_http}"
        NODE_IP = "${NOMAD_IP_http}"
      }
    }
  }
}
