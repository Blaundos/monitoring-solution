# Dockerfile to create a container for the simple monitored app
FROM python:3.9-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY app.py /app

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["python", "app.py"]
