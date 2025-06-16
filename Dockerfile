# ---------- Stage 1: Build the application ----------
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder

# Set the working directory inside the builder container
WORKDIR /app

# Copy Maven configuration and source code
COPY pom.xml .
COPY src ./src

# Build the application and package it as a JAR
RUN mvn clean package -DskipTests

# ---------- Stage 2: Create a minimal runtime image ----------
FROM openjdk:17-alpine

# Add maintainer information
LABEL maintainer="oyinkansola.wahab@hotmail.com"

# Set environment variable for app directory
ENV APP_HOME=/usr/src/app

# Set the working directory inside the final container
WORKDIR $APP_HOME

# Copy the built JAR file from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Default command to run the Java application
CMD ["java", "-jar", "app.jar"]


