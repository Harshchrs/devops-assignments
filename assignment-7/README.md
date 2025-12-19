# Assignment 7 - KIND Kubernetes deployment
Repo: https://github.com/Harshchrs/devops-assignments

Goal:
Deploy assignment-6 (frontend + backend + mongo) to local KIND cluster and prove it runs.

Files:
- k8s/mongo-deployment.yaml
- k8s/backend-deployment.yaml
- k8s/frontend-deployment.yaml
- screenshots/ (listed below)

Steps I ran (exact commands)

1. Build images locally:
   docker build -t tutedude-backend:dev ./backend
   docker build -t tutedude-frontend:dev ./frontend

2. Create a small KIND cluster (single node):
   kind create cluster --name tutedude --image kindest/node:v1.31.2

3. Load images into KIND:
   kind load docker-image tutedude-backend:dev --name tutedude
   kind load docker-image tutedude-frontend:dev --name tutedude

4. Apply k8s manifests:
   kubectl apply -f k8s/

5. Expose frontend and backend (NodePort):
   backend -> NodePort 30050
   frontend -> NodePort 30080

6. Port-forward (developer convenience):
   kubectl port-forward deploy/backend 30050:5000
   kubectl port-forward deploy/frontend 30081:3000   # or 30080 if free locally

7. Verify:
   curl http://localhost:30050/api
   curl http://localhost:30081/   # frontend page

Submission artifacts (screenshots/):
- 01_kubectl_get_pods.txt
- 02_kubectl_get_svc.txt
- 03_frontend_page.html
- 04_api_after.json
- 05_backend_logs.txt

Notes:
- Used KIND instead of Minikube due to laptop resource limits.
- If NodePort is blocked locally, port-forwarding was used and documented.
