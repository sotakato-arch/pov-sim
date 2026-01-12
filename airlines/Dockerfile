# Step 1: Use an official Gradle image to build the application
FROM gradle:8.3.0-jdk17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the entire project to the container
COPY . .

# Build the application
RUN gradle clean bootJar

# Step 2: Use a lightweight JDK image for running the app
# FROM openjdk:17-jdk-slim
FROM eclipse-temurin:17-jre

# Set the working directory for the runtime container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Copy the OpenTelemetry Java agent
COPY --from=build /app/opentelemetry-java.jar opentelemetry-java.jar

# Copy the Pyroscope Java agent
COPY --from=build /app/pyroscope.jar pyroscope.jar

# Expose the port the application runs on
EXPOSE 8080

# Set OpenTelemetry environment variables
ENV OTEL_RESOURCE_ATTRIBUTES="service.name=airlines,service.namespace=flightsim,deployment.environment=sandbox"
ENV OTEL_EXPORTER_OTLP_ENDPOINT="http://grafana-k8s-monitoring-alloy-receiver.default.svc.cluster.local:4317"
ENV OTEL_EXPORTER_OTLP_PROTOCOL="grpc"
ENV PYROSCOPE_APPLICATION_NAME="airlines"
ENV PYROSCOPE_SERVER_ADDRESS="http://my-alloy.alloy.svc.cluster.local:4040"

# Set the command to run the application
ENTRYPOINT ["java", "-javaagent:opentelemetry-java.jar", "-javaagent:pyroscope.jar", "-jar", "app.jar"]
