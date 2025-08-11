import os
import time
from celery import Celery

# Get Redis host from environment variables.
# Default to "redis" if the variable is not set.
redis_host = os.environ.get("REDIS_HOST", "redis")

# Define the broker URL. This is where tasks will be sent.
# Using database 0 for the broker.
broker_url = f"redis://{redis_host}:6379/0"

# Define the backend URL. This is where task results will be stored.
# Using database 1 for the backend.
backend_url = f"redis://{redis_host}:6379/1"

# Initialize the Celery application.
celery = Celery("tasks", broker=broker_url, backend=backend_url)

# --- Queue Configuration ---
# Setting the default queue name for all tasks.

celery.conf.task_queues = {
    # It's possible to use the standard 'routes' syntax, but this approach is often clearer.
}
celery.conf.task_default_queue = "webhook"

# --- Task Definition ---

# `@celery.task` decorator registers the function as a Celery task.
# `name="heavy_task"` gives the task a specific, recognizable name.


@celery.task(name="heavy_task")
def heavy_task(payload):
    # Simulate a "heavy" or time-consuming operation.
    # This task will sleep for 5 seconds.
    time.sleep(5)

    # Return a dictionary with a success status and an echo of the input payload.
    # The result will be stored in the backend (Redis database 1).
    return {"ok": True, "echo": payload}
