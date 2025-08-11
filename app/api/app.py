from flask import Flask, request, jsonify
from flask_cors import CORS
from celery_app import celery, heavy_task

app = Flask(__name__)
CORS(app)  # Cors for all routes


@app.route("/healthz")
def healthz():
    return "ok", 200


@app.route("/webhook", methods=["POST"])
def webhook():
    payload = request.json or {}
    # send task to "webhook"
    t = heavy_task.apply_async(args=[payload], queue="webhook")
    return jsonify({"task_id": t.id}), 202


@app.route("/status/<task_id>")
def status(task_id):
    res = celery.AsyncResult(task_id)
    return jsonify({
        "id": task_id,
        "state": res.state,
        "result": res.result if res.successful() else None
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
