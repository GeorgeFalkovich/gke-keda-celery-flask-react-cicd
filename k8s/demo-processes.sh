#!/bin/bash
echo "=== Demonstrating processes in container ==="

# Deploy the debug toolkit
kubectl apply -f k8s/debug-toolkit.yaml

# Wait for pod to be ready
echo "Waiting for pod to be ready..."
kubectl wait --for=condition=Ready pod/network-debug-toolkit --timeout=60s

# Show processes in the container
echo "=== Processes BEFORE kubectl exec ==="
kubectl exec network-debug-toolkit -c toolkit -- ps aux

echo -e "\n=== Now running kubectl exec in background ==="
# Start kubectl exec in background
kubectl exec -it network-debug-toolkit -c toolkit -- bash -c "sleep 60" &
EXEC_PID=$!

# Give it a moment to start
sleep 2

echo "=== Processes AFTER kubectl exec ==="
kubectl exec network-debug-toolkit -c toolkit -- ps aux

echo -e "\n=== Running commands in kubectl exec session ==="
kubectl exec network-debug-toolkit -c toolkit -- bash -c "
echo 'Running multiple commands:'
ps aux | head -5
echo '---'
nslookup redis > /dev/null 2>&1 &
curl -s http://api:8080/healthz > /dev/null 2>&1 &
sleep 2
ps aux | grep -E 'nslookup|curl'
"

# Cleanup background process
kill $EXEC_PID 2>/dev/null || true

echo -e "\n=== Final process list ==="
kubectl exec network-debug-toolkit -c toolkit -- ps aux
