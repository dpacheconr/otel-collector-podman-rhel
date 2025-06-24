#!/bin/zsh
# deploy_otel_collector.sh
# Deploy OpenTelemetry Collector using Podman with config from local YAML

set -euo pipefail

# Name of the config file (must be in the same directory as this script)
CONFIG_FILE="otel-collector-config.yaml"

# Name for the Podman container
CONTAINER_NAME="otel-collector"

# OpenTelemetry Collector contrib image (for extra receivers/exporters like Solace)
OTEL_IMAGE="otel/opentelemetry-collector-contrib:latest"

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if config file exists
if [[ ! -f "$SCRIPT_DIR/$CONFIG_FILE" ]]; then
  echo "Error: $CONFIG_FILE not found in $SCRIPT_DIR"
  exit 1
fi

# Remove any existing container with the same name
if podman ps -a --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
  echo "Removing existing container $CONTAINER_NAME..."
  podman rm -f "$CONTAINER_NAME"
fi

# Run the OpenTelemetry Collector
podman run -d \
  --name "$CONTAINER_NAME" \
  -v "$SCRIPT_DIR/$CONFIG_FILE:/etc/otelcol/config.yaml:ro" \
  -p 4317:4317 \
  -p 4318:4318 \
  "$OTEL_IMAGE" \
  --config /etc/otelcol/config.yaml

echo "OpenTelemetry Collector deployed as container '$CONTAINER_NAME' using config '$CONFIG_FILE'."
