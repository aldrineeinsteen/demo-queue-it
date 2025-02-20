resource "null_resource" "install_kots" {
  provisioner "local-exec" {
    command = <<EOT
      export KUBECONFIG="${path.root}/modules/lke/kubeconfig"

      if ! command -v kots &> /dev/null; then
        curl -sSL https://kots.io/install | REPL_INSTALL_PATH=$HOME/bin bash
      fi
    EOT
  }

  depends_on = [null_resource.install_kots]
}

provider "kubernetes" {
  config_path = var.kubeconfig
}