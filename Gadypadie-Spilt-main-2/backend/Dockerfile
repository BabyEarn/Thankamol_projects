# ---- Build stage: สร้าง executable JAR ----
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# ควรแยก copy pom ก่อนเพื่อ cache dependency
COPY pom.xml .
# ใช้ cache ของ Maven เพื่อลดเวลาลง
RUN --mount=type=cache,target=/root/.m2 mvn -q -DskipTests dependency:go-offline

# ค่อย copy src แล้ว build + repackage
COPY src ./src
RUN --mount=type=cache,target=/root/.m2 mvn -q clean package spring-boot:repackage -DskipTests

# ---- Runtime stage: รันแอปจริง ----
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
