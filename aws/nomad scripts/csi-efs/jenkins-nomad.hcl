job "jenkins-server" {
  datacenters = ["dc1"]
  type        = "service"

  group "jenkins" {
    count = 1

    # Definimos el volumen que registraste
    volume "jenkins_efs" {
      type            = "csi"
      source          = "fs-014870fcedfd1c584"          # <- ID/Name que registraste
      access_mode     = "multi-node-multi-writer" # Puedes usar single-node-writer si prefieres
      attachment_mode = "file-system"
      read_only       = false
    }

    network {
      port "http" {
        static = 8080
      }
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "jenkins" {
      driver = "docker"

      config {
        image = "jenkins/jenkins:lts"    # Imagen oficial de Jenkins LTS
        ports = ["http"]

        # Directorio de datos persistentes de Jenkins
        volumes = [
          "local/jenkins_home:/var/jenkins_home" # Para datos temporales si quieres algo local también (opcional)
        ]
      }

      # Montamos el volumen EFS
      volume_mount {
        volume      = "jenkins_efs"
        destination = "/var/jenkins_home"   # Jenkins home donde se guardan configuraciones, builds, etc.
        read_only   = false
      }

      env {
        JAVA_OPTS = "-Djenkins.install.runSetupWizard=false" # Opcional: Deshabilita el wizard de setup inicial
      }

      resources {
        cpu    = 1000
        memory = 2048
      }

      service {
        name = "jenkins"
        port = "http"

        check {
          type     = "http"
          path     = "/login"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
