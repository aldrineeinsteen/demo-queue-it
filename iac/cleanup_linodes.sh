#!/bin/bash

# Set your Linode CLI profile if required
# export LINODE_CLI_TOKEN="your-api-token"

# Get LKE cluster ID
CLUSTER_ID=$(linode-cli lke clusters-list --json | jq -r '.[] | select(.label=="queueit-demo-cluster") | .id')

if [ -z "$CLUSTER_ID" ]; then
  echo "❌ No LKE cluster found with label 'queueit-demo-cluster'. Exiting."
  exit 1
fi

echo "🛑 Deleting Linode Kubernetes Engine (LKE) Cluster: $CLUSTER_ID ..."
linode-cli lke cluster-delete "$CLUSTER_ID" --no-headers --json
echo "✅ LKE cluster deleted."

# Get all attached volumes
VOLUMES=$(linode-cli volumes list --json | jq -r '.[] | select(.region=="gb-lon") | .id')

if [ -z "$VOLUMES" ]; then
  echo "✅ No Linode Volumes found in 'gb-lon'."
else
  for VOLUME_ID in $VOLUMES; do
    echo "🛑 Deleting Linode Volume: $VOLUME_ID ..."
    linode-cli volumes delete "$VOLUME_ID"
    echo "✅ Volume $VOLUME_ID deleted."
  done
fi

# Optional: Clean up orphaned NodeBalancers
NODEBALANCERS=$(linode-cli nodebalancers list --json | jq -r '.[].id')
if [ -n "$NODEBALANCERS" ]; then
  for NB_ID in $NODEBALANCERS; do
    echo "🛑 Deleting NodeBalancer: $NB_ID ..."
    linode-cli nodebalancers delete "$NB_ID"
    echo "✅ NodeBalancer $NB_ID deleted."
  done
else
  echo "✅ No NodeBalancers found."
fi

echo "🎯 Cleanup complete!"