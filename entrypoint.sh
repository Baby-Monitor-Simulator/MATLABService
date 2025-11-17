#!/bin/sh
set -e  # Exit immediately if a command exits with a non-zero status

echo "Starting entrypoint script..."
echo "Current working directory:"
pwd
echo "Listing files:"
ls -la

# Check if mvnw exists and is executable
if [ ! -f ./mvnw ]; then
    echo "mvnw not found!"
    exit 1
elif [ ! -x ./mvnw ]; then
    echo "mvnw is not executable! Attempting to set it as executable..."
    chmod +x ./mvnw
    if [ ! -x ./mvnw ]; then
        echo "Failed to make mvnw executable!"
        exit 1
    else
        echo "mvnw is now executable."
    fi
else
    echo "mvnw is already executable."
fi

# Run Maven command to start the Spring Boot application
exec sh ./mvnw spring-boot:run