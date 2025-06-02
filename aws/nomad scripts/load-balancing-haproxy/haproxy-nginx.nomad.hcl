job "haproxy" {
  datacenters = ["dc1"]
  type        = "service"

  group "haproxy" {
    count = 1

    task "haproxy" {
      driver = "docker"

      config {
        image        = "haproxy:2.0"
        network_mode = "host"

        volumes = [
          "local/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg",
        ]
      }

      resources {
        cpu    = 200
        memory = 128
      }

      template {
        data = <<EOF
global
  daemon
  maxconn 256

defaults
  mode http
  timeout connect 5000ms
  timeout client  50000ms
  timeout server  50000ms

frontend http_front
  bind *:8080
  default_backend nginx_back

backend nginx_back
  balance roundrobin
  server-template nginx 1 nginx.service.consul:80 check resolvers consul resolve-prefer ipv4

resolvers consul
  nameserver consul 127.0.0.1:8600
  accepted_payload_size 8192
  hold valid 5s
EOF

        destination = "local/haproxy.cfg"
      }

      service {
        name = "haproxy"
        tags = ["proxy"]

        check {
          name         = "tcp"
          type         = "tcp"
          port         = 8080
          address_mode = "driver"
          interval     = "10s"
          timeout      = "2s"
        }
      }
    }
  }
}
