import os, traceback
from flask import Flask, request, jsonify
from pymongo import MongoClient, errors

app = Flask(__name__)

MONGO_URI = os.environ.get("MONGO_URI", "mongodb://mongo:27017/")
USE_MEMORY = os.environ.get("USE_MEMORY", "true").lower() == "true"

collection = None
memory_store = []

if not USE_MEMORY:
    try:
        client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=3000)
        client.server_info()   # quick check
        db = client["assignment6_db"]
        collection = db["data"]
        print("Mongo connected:", MONGO_URI)
    except Exception:
        traceback.print_exc()
        print("Mongo connect failed, switching to memory")
        USE_MEMORY = True

@app.route("/api", methods=["GET"])
def get_data():
    try:
        if USE_MEMORY or collection is None:
            return jsonify(memory_store)
        return jsonify(list(collection.find({}, {"_id": 0})))
    except Exception as e:
        traceback.print_exc()
        return jsonify({"error":"internal","detail":str(e)}),500

@app.route("/submit", methods=["POST"])
def submit_data():
    try:
        item_name = request.form.get("name") or request.form.get("itemName")
        item_desc = request.form.get("email") or request.form.get("itemDescription")
        if not item_name or not item_desc:
            return "Missing data", 400
        obj = {"itemName": item_name, "itemDescription": item_desc}
        if USE_MEMORY or collection is None:
            memory_store.append(obj)
        else:
            collection.insert_one(obj)
        return "Data submitted successfully"
    except Exception:
        traceback.print_exc()
        return "Internal server error",500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False, use_reloader=False)
