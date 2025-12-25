import pymongo
import random
import time
from datetime import datetime

# 1. Connect to MongoDB (Localhost)
client = pymongo.MongoClient("mongodb://localhost:27017/")
db = client["my_online_store"]
collection = db["orders"]

print(" Connected to MongoDB. Starting data seed...")

# 2. Generate Dummy Data
products = ["Laptop", "Mouse", "Keyboard", "Monitor", "Headphones", "USB Cable"]
statuses = ["Completed", "Pending", "Shipped", "Cancelled"]

new_orders = []
for i in range(1000):  # Generating 1000 orders
    order = {
        "user_id": random.randint(1000, 9999),
        "product": random.choice(products),
        "price": random.randint(10, 2000),
        "status": random.choice(statuses),
        "created_at": datetime.now().isoformat()
    }
    new_orders.append(order)

# 3. Insert into Database
result = collection.insert_many(new_orders)

print(f" Success! Inserted {len(result.inserted_ids)} new orders into the 'my_online_store' database.")
print(f" Total documents in collection: {collection.count_documents({})}")
