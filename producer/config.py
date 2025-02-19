import os

# Stargate API Configurations
STARGATE_URL = os.getenv("STARGATE_URL", "http://external-ip:8082/v2")
AUTH_TOKEN = os.getenv("AUTH_TOKEN", "")  # If authentication is required

# Cassandra Namespace & Collection
NAMESPACE = "queue_demo"
COLLECTION = "messages"

# Headers for REST API Requests
HEADERS = {
    "Content-Type": "application/json",
    "X-Cassandra-Token": AUTH_TOKEN  # Optional, if authentication is needed
}
# Dummy Push - 1