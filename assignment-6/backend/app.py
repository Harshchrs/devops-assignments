from flask import Flask, request, jsonify
from pymongo import MongoClient

app = Flask(__name__)

# Connect to local MongoDB (or change URI for Atlas)
client = MongoClient("mongodb://localhost:27017/")
db = client["assignment6_db"]
collection = db["data"]

# API route
@app.route("/api", methods=["GET"])
def get_data():
    data = list(collection.find({}, {"_id": 0}))
    return jsonify(data)

# Route to insert data from frontend form
@app.route("/submit", methods=["POST"])
def submit_data():
    item_name = request.form.get("itemName")
    item_desc = request.form.get("itemDescription")
    if not item_name or not item_desc:
        return "Missing data", 400
    collection.insert_one({"itemName": item_name, "itemDescription": item_desc})
    return "Data submitted successfully"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
