# demo-queue-it

execution:
```bash
terraform init -upgrade
terraform fmt
terraform validate
terraform plan -target=module.lke
terraform apply -target=module.lke -auto-approve
terraform plan -target=module.namespace
terraform apply -target=module.namespace -auto-approve
terraform plan -target=module.storage
terraform apply -target=module.storage -auto-approve
terraform plan -target=module.stateful-set
terraform apply -target=module.stateful-set  -auto-approve
terraform plan
terraform apply -auto-approve
```


destroy:
```bash
terraform destroy -auto-approve
```


export KUBECONFIG=./modules/lke/kubeconfig
kubectl apply -f https://github.com/jetstack/cert-manager/releases/latest/download/cert-manager.yaml


kubectl-kots install mission-control \
  --namespace mc-system \
  --license-file "./license/mc_license.yaml" \
  --storage-class mc-storage-class \
  --no-port-forward \
  --shared-password="password" \
  --wait-duration=10m


kubectl kots install mission-control --namespace mission-control \
  --license-file "./license/mc_license.yaml" \
  --shared-password="password" \
  --config-values "./config/mc_config.yaml" \
  --storage-class linode-block-storage-retain \
  --no-port-forward


linode-cli obj mb mission-control --cluster gb-lon
linode-cli obj mb mission-control --cluster us-east-1
linode-cli obj mb mission-control --cluster us-east-1
linode-cli obj mb my_mimir_bucket --cluster us-east-1
linode-cli obj mb loki-chunks --cluster us-east-1


[{"id": 1778888, "label": "mission-control-key", "access_key": "S5D2NIWCMRFU78S4OZVB", "secret_key": "uYbhJ6KRQqVA6Xk3rI15ggNjMDQC3kkzJuKxpGRU", "limited": true, "bucket_access": [{"cluster": "us-east-1", "bucket_name": "mission-control", "permissions": "read_write", "region": "us-east"}], "regions": [{"id": "us-east", "s3_endpoint": "us-east-1.linodeobjects.com", "endpoint_type": "E0"}]}]


export KUBECONFIG=./module/lke/kubeconfig


kubectl kots admin-console --namespace mission-control


kubectl label node lke351557-553509-0e3a16780000 mission-control.datastax.com/role=platform

export CASSANDRA_NS="sample-p4yu2951"
export CASSANDRA_URL="$(kubectl get nodes -o wide --no-headers | awk 'NR==1{print $7}')":$(kubectl get svc hcd-demo-gb-lon-dc-1-data-api-np -n $CASSANDRA_NS -o jsonpath='{.spec.ports[0].nodePort}')
echo "CASSANDRA_URL=$CASSANDRA_URL"
export CASSANDRA_USERNAME=$(kubectl get secret hcd-demo-superuser -n $CASSANDRA_NS -o jsonpath="{.data.username}" | base64 --decode | base64)
export CASSANDRA_PASSWORD=$(kubectl get secret hcd-demo-superuser -n $CASSANDRA_NS -o jsonpath="{.data.password}" | base64 --decode | base64)
echo "Cassandra:$CASSANDRA_USERNAME:$CASSANDRA_PASSWORD"

Cassandra:ZGVtby1zdXBlcnVzZXI=:cGFzc3dvcmQ=


curl -sS --location -X POST "http://$CASSANDRA_URL/v1/" \
--header "Token: Cassandra:$CASSANDRA_USERNAME:$CASSANDRA_PASSWORD" \
--header "Content-Type: application/json" \
--data '{"createKeyspace": {"name": "demo_ks"}}'


curl -sS --location -X POST "http://$CASSANDRA_URL/v1/demo_ks/events" \
--header "Token: Cassandra:$CASSANDRA_USERNAME:$CASSANDRA_PASSWORD" \
--header "Content-Type: application/json" \
--data '{"find": {}}'


kubectl logs mission-control-mimir-compactor-0 -n mission-control >> ./logs/mc.log
kubectl logs mission-control-mimir-ingester-0 -n mission-control >> ./logs/mc.log
kubectl logs mission-control-mimir-querier-5967c675f5-lztdg -n mission-control >> ./logs/mc.log
kubectl logs mission-control-mimir-store-gateway-0 -n mission-control >> ./logs/mc.log
kubectl logs loki-backend-0 -n mission-control >> ./logs/mc.log


source ~/.venvs/linode-cli/bin/activate



for i in {1..10}; do
    curl -sS --location -X POST "http://$CASSANDRA_URL/v1/demo_ks/demo_collection" \
    --header "Token: Cassandra:$CASSANDRA_USERNAME:$CASSANDRA_PASSWORD" \
    --header "Content-Type: application/json" \
    --data "{\"insertOne\": {\"document\": {\"id\": $i, \"name\": \"User_$i\", \"age\": $((20 + i))}}}"
done


export CASSANDRA_URL=172.236.30.71:32760