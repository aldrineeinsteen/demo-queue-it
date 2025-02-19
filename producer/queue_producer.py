from fastapi import FastAPI, HTTPException
import requests
import os
from datetime import datetime
import uuid

# Configurable Environment Variables
STARGATE_URL = os.getenv("STARGATE_URL", "http://external-ip:8082/v2")
AUTH_TOKEN = os.getenv("AUTH_TOKEN", "")  # If needed for authentication
NAMESPACE = "queue_demo"
COLLECTION = "messages"

HEADERS = {
    "Content-Type": "application/json",
    "X-Cassandra-Token": AUTH_TOKEN  # Only needed if authentication is required
}

app = FastAPI()

@app.post("/enqueue/")
async def enqueue_message(queue_name: str, message: str):
    """Accepts messages and pushes them to Cassandra queue via Data API"""
    payload = {
        "queue_name": queue_name,
        "message": message,
        "created_at": datetime.utcnow().isoformat(),
        "message_id": str(uuid.uuid4())
    }

    url = f"{STARGATE_URL}/namespaces/{NAMESPACE}/collections/{COLLECTION}"
    response = requests.post(url, json=payload, headers=HEADERS)

    if response.status_code == 201:
        return {"status": "Message Enqueued", "message": payload}
    else:
        raise HTTPException(status_code=500, detail=f"Error: {response.text}")

@app.get("/")
async def health_check():
    """Health check endpoint"""
    return {"status": "Producer is running!"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)