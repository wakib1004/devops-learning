# Use a lightweight python 3.9 base image 
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Python application into the container
COPY app.py .

# Execute the Python application when the container starts
CMD ["python3", "app.py"]
