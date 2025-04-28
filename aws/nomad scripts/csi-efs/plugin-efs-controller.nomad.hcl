job "plugin-aws-efs-controller" {
  datacenters = ["dc1"]

  group "controller" {
    task "plugin" {
      driver = "docker"

      config {
        image = "amazon/aws-efs-csi-driver:v1.7.4"  # Usa una versión reciente

        args = [
          "--endpoint=unix://csi/csi.sock",
          "--logtostderr",
          "--v=5",
        ]
      }

      csi_plugin {
        id        = "aws-efs0"
        type      = "controller"
        mount_dir = "/csi"
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
