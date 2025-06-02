job "haproxy" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "haproxy" {
    count = 1

    task "haproxy" {
      driver = "docker"

      config {
        image = "haproxy:2.0"
        ports = ["http", "haproxy_ui"]

        volumes = [
          "local/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg",
        ]
      }

      resources {
        cpu    = 200
        memory = 128
        network {
          port "http" {
            static = 8080
          }

          port "haproxy_ui" {
            static = 1936
          }
        }
      }

      service {
        name = "haproxy"
        port = "http"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      template {
        data = <<EOF
defaults
   mode http

frontend stats
   bind *:1936
   stats uri /
   stats show-legends
   no log

frontend http_front
   bind *:8080
   default_backend http_back

backend http_back
    balance roundrobin
    server-template mywebapp 10 _demo-webapp._tcp.service.consul resolvers consul resolve-opts allow-dup-ip resolve-prefer ipv4 check

resolvers consul
    nameserver consul 127.0.0.1:8600
    accepted_payload_size 8192
    hold valid 5s
EOF

        destination = "local/haproxy.cfg"
      }
    }
  }
}
