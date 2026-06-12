#!/usr/bin/env bash

LOCATION="eastus"

# Preferred VM sizes in order
SIZES=(
  "Standard_B1s"
  "Standard_B1ms"
  "Standard_B2s"
  "Standard_DS1_v2"
)

for SIZE in "${SIZES[@]}"; do
  AVAILABLE=$(az vm list-skus \
    --location "$LOCATION" \
    --size "$SIZE" \
    --query "[?resourceType=='virtualMachines' && restrictions==[]].name | length(@)" \
    -o tsv)

  if [[ "$AVAILABLE" -gt 0 ]]; then
    echo "{\"size\": \"$SIZE\"}"
    exit 0
  fi
done

echo "{\"error\": \"No suitable VM size available\"}"
exit 1

