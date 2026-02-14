# Stage 1: Build using the official Java 25 image
FROM eclipse-temurin:25-jdk AS build
WORKDIR /app

# Install Maven manually (since it's not in the base JDK image)
RUN apt-get update && apt-get install -y maven

COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run using the lightweight Alpine version
FROM eclipse-temurin:25-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/auth-service-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]