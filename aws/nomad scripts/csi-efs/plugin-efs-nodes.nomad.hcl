job "plugin-aws-efs-nodes" {
  datacenters = ["dc1"]
  type = "system"

  group "nodes" {
    task "plugin" {
      driver = "docker"

      config {
        image = "amazon/aws-efs-csi-driver:v1.7.4"

        args = [
          "--endpoint=unix://csi/csi.sock",
          "--logtostderr",
          "--v=5",
        ]
        privileged = true
      }

      csi_plugin {
        id        = "aws-efs0"
        type      = "node"
        mount_dir = "/csi"
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
