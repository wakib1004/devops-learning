# Title

<Description>

## What I built 

### 1. Created a Python application 

```python
def say_hello():
    return "Hello, World!"

if __name__ == "__main__":
    print(say_hello())
```
Created a simple Python application (app.py) that prints Hello, World!.

---

### 2. Created a Dockerfile 

```dockerfile
# Use a lightweight python 3.9 base image 
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Python application into the container
COPY app.py .

# Execute the Python application when the container starts
CMD ["python3", "app.py"]
```

Created the Dockerfile to define the instructions required to build a Docker image containing the Python application.

---

### 3. Created a repository secret and a repository variable

- `DOCKERHUB_TOKEN`: Created a repository secret containing my Docker Hub access token. This token is used to authenticate with Docker Hub during the GitHub Actions workflow.

- `DOCKERHUB_USERNAME`: Created a repository variable containing my Docker Hub username, which is used to identify my Docker Hub account when pushing the image.

---

### 4. Created a GitHub Actions Workflow

Created a GitHub Actions workflow named `ci.yaml` inside the `.github/workflows` directory at the root of the repository. GitHub automatically detects workflow files placed in this directory and executes them.

```yaml
# Name of the GitHub Actions workflow
name: Build and push container image to DockerHub

# Trigger the workflow whenever code is pushed to the repository
on: [push]

# Define the jobs to be executed
jobs:
  docker:
    # Run the job on an Ubuntu virtual machine
    runs-on: ubuntu-latest

    # Define the steps to execute
    steps:

      # Step 1 - Download the repository source code
      - name: Checkout repository
        uses: actions/checkout@v6

      # Step 2 - Authenticate with Docker Hub
      - name: Login to Docker Hub
        uses: docker/login-action@v4
        with:
          # Docker Hub username stored as a GitHub repository variable
          username: ${{ vars.DOCKERHUB_USERNAME }}

          # Docker Hub access token stored as a GitHub secret
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      # Step 3 - Set up QEMU for emulation and multi-platform builds
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v4

      # Step 4 - Set up Docker Buildx for building container images
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v4

      # Step 5 - Build the Docker image and push it to Docker Hub
      - name: Build and push
        uses: docker/build-push-action@v7
        with:
          # Specify the directory containing the Dockerfile and application
          context: ./cicd/task-1

          # Push the built image to Docker Hub
          push: true

          # Pushes the image to Docker Hub with the `latest` tag.
          tags: ${{ vars.DOCKERHUB_USERNAME }}/python-app:latest
```
This workflow builds and pushes the container image to Docker Hub whenever code is pushed to the repository.

---









