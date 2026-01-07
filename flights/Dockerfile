# Use the official Python 3.8 image as the base image
FROM python:3.8-slim-buster

# Set the working directory inside the container
WORKDIR /python-docker

# Copy the requirements file into the container
COPY requirements.txt requirements.txt

# Install the required dependencies
RUN pip3 install -r requirements.txt

# Copy the rest of your application code into the container
COPY . .

# Install the OpenTelemetry agent
RUN opentelemetry-bootstrap -a install

# Expose port 5001
EXPOSE 5001

ENV OTEL_RESOURCE_ATTRIBUTES="service.name=flights,service.namespace=flightsim,deployment.environment=sandbox"
ENV OTEL_EXPORTER_OTLP_ENDPOINT="https://otlp-gateway-prod-ap-northeast-0.grafana.net/otlp"
ENV OTEL_EXPORTER_OTLP_PROTOCOL="http/protobuf"
ENV OTEL_PYTHON_LOGGING_AUTO_INSTRUMENTATION_ENABLED="true"
ENV OTEL_EXPORTER_OTLP_HEADERS="Authorization=Basic MTQ1ODY0ODpnbGNfZXlKdklqb2lNVFl3TlRZM01TSXNJbTRpT2lKemRHRmpheTB4TkRVNE5qUTRMVzkwYkhBdGQzSnBkR1V0Wm14cFoyaDBMWE5wYlMxa1pXMXZJaXdpYXlJNklqUTNibWR1T1dsNGVXUTJOMFZvVnpZeU5VSkZVRTA0TmlJc0ltMGlPbnNpY2lJNkluQnliMlF0WVhBdGJtOXlkR2hsWVhOMExUQWlmWDA9"
# Specify the command to run your Flask app

CMD ["opentelemetry-instrument", "--traces_exporter", "otlp", "--metrics_exporter", "otlp", "python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=5001"]
