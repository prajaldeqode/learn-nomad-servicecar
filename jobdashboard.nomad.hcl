job "dashboard" {
    datacenters = ["dc2"]
    group "dashboard" {
    network {
      mode = "bridge"

      port "http" {
        to     = 9002
      }
    }

    service {
      name = "count-dashboard"
      port = "http"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "count-api"
              local_bind_port  = 8080
            }
          }
        }
      }
    }

    task "dashboard" {
      driver = "docker"

      env {
        COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
      }

      config {
        image = "hashicorpdev/counter-dashboard:v3"
      }
    }
  }
}
