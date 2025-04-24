job "tetris" {
  datacenters = ["dc1"]

  # Constraints definition
  constraint {
    attribute = "${meta.owner}"
    value     = "jhorland"
  }

  group "games" {
    count = 5

    # Dinamic host port
    network {
      mode = "host"
      port "web" {
        to = 80
      }
    }

    # Dinamic host port with bridge mode
    # network {
    #   mode = "bridge"
    #   port "web" {
    #     to = 80
    #   }
    # }

    # Fixed host port not recommended
    # network {
    #   mode = "host"
    #   port "web" {
    #     static = 80
    #     to = 80
    #   }
    # }

    

    # spread {
    #   attribute = "${node.unique.id}"
    # }

    spread {
      attribute = "${attr.platform.aws.placement.availability-zone}"
      weight = 100
      target "us-west-2b" {
        percent = 100
      }
      target "us-west-2a" {
        percent = 0
      }
    }

    constraint {
      attribute = "${meta.owner}"
      value     = "jhorland"
    }

    # volumen definitions
    volume "database" {
      type = "host"
      source = "database"
      read_only = false
    }

    task "tetris" {
      driver = "docker"

      # volumen mount definition
      volume_mount {
        volume = "database"
        destination = "/var/lib/http"
        read_only = false
      }

      config {
        image          = "bsord/tetris"
        ports          = ["web"]
        auth_soft_fail = true
      }

      resources {
        cpu    = 50
        memory = 256
      }
    }
  }
}