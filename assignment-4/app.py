from flask import Flask, jsonify, request, render_template, redirect
from pymongo import MongoClient

app = Flask(__name__)

# Connect to MongoDB Atlas
client = MongoClient("your_mongodb_connection_string_here")
db = client['assignment_db']
collection = db['users']

# API route
data = [
    {"name": "Batman", "role": "DevOps"},
    {"name": "Robin", "role": "Frontend"}
]

@app.route('/api')
def api():
    return jsonify(data)

# Frontend routes
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/submit', methods=['POST'])
def submit():
    try:
        name = request.form['name']
        role = request.form['role']
        collection.insert_one({"name": name, "role": role})
        return redirect('/success')
    except Exception as e:
        return render_template('index.html', error=str(e))

@app.route('/success')
def success():
    return render_template('success.html')

if __name__ == "__main__":
    app.run(debug=True)

