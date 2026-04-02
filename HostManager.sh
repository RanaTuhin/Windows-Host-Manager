#!/bin/bash

HOSTS_FILE="/etc/hosts"

# Ask for domain
read -p "Enter domain (e.g. laravel.test): " DOMAIN

# Check admin (sudo)
if [[ $EUID -ne 0 ]]; then
  echo "Please run this script with sudo!"
  exit 1
fi

# Check duplicate
if grep -iq "$DOMAIN" "$HOSTS_FILE"; then
  echo "Domain already exists!"
  exit 1
fi

# Temp file
TEMP_FILE=$(mktemp)

# Insert after localhost
while IFS= read -r line; do
  echo "$line" >> "$TEMP_FILE"

  if echo "$line" | grep -qE "127\.0\.0\.1[[:space:]]+localhost"; then
    echo "127.0.0.1    $DOMAIN" >> "$TEMP_FILE"
  fi
done < "$HOSTS_FILE"

# Replace original
cp "$TEMP_FILE" "$HOSTS_FILE"
rm "$TEMP_FILE"

echo "Added $DOMAIN with proper spacing!"
