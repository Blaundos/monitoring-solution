from flask import Flask, jsonify
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app)

@app.route('/')
def hello_world():
    return jsonify(message="Hello, World! This is a monitored app.")

@app.route('/status')
def status():
    return jsonify(status="OK")

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
