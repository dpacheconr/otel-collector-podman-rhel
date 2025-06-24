# OpenTelemetry Collector Deployment with Podman (RHEL)

This guide explains how to deploy the OpenTelemetry Collector (contrib version) using Podman on Red Hat Enterprise Linux (RHEL). It includes configuration for the Solace receiver and New Relic OTLP HTTP exporter.

## Prerequisites
- RHEL 8 or newer
- Podman installed
- OpenTelemetry Collector configuration file (e.g., `config.yaml`)
- (Optional) New Relic license key for exporting traces

## Files
- `deploy_otel_collector.sh`: Shell script to deploy the collector
- `config.yaml`: OpenTelemetry Collector configuration (edit as needed)
- `config.yaml.example`: Example configuration file. Copy this to `config.yaml` and update with your own values before deploying.

## Steps

### 1. Place Files
Copy `deploy_otel_collector.sh` and your `config.yaml` into the same directory on your RHEL machine.

### 2. Make the Script Executable
```
chmod +x deploy_otel_collector.sh
```

### 3. Edit the Configuration
- Copy `config.yaml.example` to `config.yaml`:
  ```
  cp config.yaml.example config.yaml
  ```
- Update `config.yaml` with your Solace and New Relic details.
- Ensure your New Relic license key is set in the exporter section.

### 4. Deploy the Collector
```
./deploy_otel_collector.sh
```

The script will:
- Remove any existing collector container with the same name
- Start a new container using the contrib image
- Mount your config file into the container
- Expose ports 4317 (gRPC) and 4318 (HTTP)

### 5. Verify Deployment
Check that the container is running:
```
podman ps
```

View logs:
```
podman logs otel-collector
```

## Notes
- The script uses the contrib image (`otel/opentelemetry-collector-contrib:latest`) for extra receivers/exporters like Solace.
- Adjust ports and config file names as needed.
- For production, consider using a specific image version instead of `latest`.

---

For more information, see the [OpenTelemetry Collector documentation](https://opentelemetry.io/docs/collector/) and [Podman documentation](https://podman.io/getting-started/).
