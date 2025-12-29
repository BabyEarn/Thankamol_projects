up:
	docker compose up --build

down:
	docker compose down -v

test-backend:
	./mvnw -q -f backend/pom.xml test

test-frontend:
	cd frontend && npm i && npm test

e2e:
	cd frontend && npx cypress run
