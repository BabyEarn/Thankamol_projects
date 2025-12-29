# GPSplit — Group Expense Splitter (Full Deploy)

A real‑world DevOps semester project, ready to run **locally** with Docker Compose or **on Minikube** with Kubernetes.
Includes: React+Vite frontend, Spring Boot backend (MySQL), CI example (Jenkinsfile), Cypress e2e, Prometheus+Grafana basics.

## Ports (avoid conflicts)
- Frontend (Vite dev): **8081**
- Backend (Spring Boot): **8080**
- MySQL: **3306**
- Grafana: **3000**
- Prometheus: **9090**
- Ingress (Minikube): frontend at **http://app.local/**, backend at **http://api.local/**

## Quick Start (Docker Compose)
1. Copy `.env.example` to `.env` and adjust if needed.
2. `docker compose up --build`
3. Open frontend: http://localhost:8081
4. Open backend health: http://localhost:8080/actuator/health
5. Open Grafana: http://localhost:3000  (user: admin / pass: admin)

## Quick Start (Minikube)
1. `minikube start`
2. `kubectl apply -f infra/k8s/namespace.yaml`
3. `kubectl config set-context --current --namespace=gpsplit`
4. `kubectl apply -f infra/k8s/mysql.yaml`
5. `kubectl apply -f infra/k8s/backend.yaml`
6. `kubectl apply -f infra/k8s/frontend.yaml`
7. `kubectl apply -f infra/k8s/ingress.yaml`
8. Add to your `/etc/hosts`:

   ```

   127.0.0.1 app.local api.local
   ```
   and run `minikube tunnel` (or use `minikube service` for NodePort testing).

## Test
- Unit & Integration: `./mvnw -q -f backend/pom.xml test`
- Frontend unit: `cd frontend && npm i && npm test`
- Cypress e2e (with docker compose up): `cd frontend && npx cypress run`

## Seed Login
- Username: `demo`
- Password: `demo123`

## Features
- Multi-user (simple session/JWT), groups, participants, expenses
- Custom splits: equal / amount / percent / tag-based
- Settlement suggestions (min transactions greedy)
- Currency import via CSV (configurable rates); stores original amounts+currency
- Receipt upload (local), PromptPay QR payload generate, Export PDF stub
- Observability: Spring Boot Actuator + Micrometer (Prometheus), Grafana dashboards
- CI sample pipeline (build → test → e2e → push → deploy)

## Dev Notes
- Backend uses profile `dev` by default (MySQL via env). H2 is used in tests.
- Cypress runs against `http://localhost:8081` (frontend) and `http://localhost:8080` (backend).
- Change any port in `.env` and manifests if needed.
