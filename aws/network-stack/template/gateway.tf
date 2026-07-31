resource "null_resource" "install_gw_crds" {
  provisioner "local-exec" {
    command = <<EOF
        kubectl apply \
          --server-side \
          -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v${var.gateway_crds_version}/standard-install.yaml

    EOF
  }
}
