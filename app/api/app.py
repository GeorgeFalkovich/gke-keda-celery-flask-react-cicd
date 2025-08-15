from flask import Flask, request, jsonify
from celery_app import celery, heavy_task

app = Flask(__name__)
# Configure Flask-CORS if needed


@app.route("/healthz")
def healthz():
    return "ok", 200


@app.route("/api/webhook", methods=["POST"])
def webhook():
    payload = request.json or {}
    # send task to "webhook"
    t = heavy_task.apply_async(args=[payload], queue="webhook")
    return jsonify({"task_id": t.id}), 202


@app.route("/api/status/<task_id>")
def status(task_id):
    res = celery.AsyncResult(task_id)
    return jsonify({
        "id": task_id,
        "state": res.state,
        "result": res.result if res.successful() else None
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
