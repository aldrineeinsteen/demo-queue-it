resource "null_resource" "deploy_mission_control" {
  provisioner "local-exec" {
    command = <<EOT
      export KUBECONFIG="${var.kubeconfig}"
      export PATH=$HOME/bin:$PATH

      # Generate a custom configuration file for Mission Control
      cat <<EOF > /tmp/mc-config.yaml
      apiVersion: kots.io/v1beta1
      kind: ConfigValues
      metadata:
        name: mission-control
        namespace: mc-system
      spec:
        values:
          serviceAccount:
            value: mc-service-account
      EOF

      # Deploy Mission Control using KOTS
      kubectl-kots install mission-control \
        --namespace ${var.namespace} \
        --license-file "${path.root}/license/mc_license.yaml" \
        --storage-class mc-storage-class \
        --no-port-forward \
        --shared-password="${var.admin_password}" \
        --wait-duration=10m

      kubectl apply -f /tmp/mc-config.yaml -n mc-system
    EOT
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig
}