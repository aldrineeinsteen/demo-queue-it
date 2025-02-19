import requests
import time
import uuid
from config import STARGATE_URL, NAMESPACE, COLLECTION, HEADERS

def fetch_messages():
    """Fetch messages from the queue collection."""
    url = f"{STARGATE_URL}/namespaces/{NAMESPACE}/collections/{COLLECTION}"
    response = requests.get(url, headers=HEADERS)
    
    if response.status_code == 200:
        data = response.json().get("data", [])
        return data
    else:
        print(f"Error fetching messages: {response.text}")
        return []

def process_message(message):
    """Simulate message processing."""
    print(f"Processing Message: {message['message']} (Queue: {message['queue_name']})")
    time.sleep(2)  # Simulate processing time

def delete_message(message_id):
    """Delete processed message from the queue."""
    url = f"{STARGATE_URL}/namespaces/{NAMESPACE}/collections/{COLLECTION}/{message_id}"
    response = requests.delete(url, headers=HEADERS)
    
    if response.status_code == 204:
        print(f"✅ Deleted message {message_id}")
    else:
        print(f"⚠️ Failed to delete message {message_id}: {response.text}")

def consume_messages():
    """Main loop to continuously consume messages."""
    while True:
        messages = fetch_messages()
        
        if not messages:
            print("No messages in queue. Waiting...")
            time.sleep(5)
            continue

        for msg in messages:
            process_message(msg)
            delete_message(msg["_id"])

if __name__ == "__main__":
    consume_messages()