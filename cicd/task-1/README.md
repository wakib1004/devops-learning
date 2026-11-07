# Building and Pushing a Container Image Using a GitHub Actions Workflow

This project demonstrates how I automated building and pushing a Docker image for a Python application to Docker Hub using GitHub Actions whenever code is pushed to the repository.

---

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

- `DOCKERHUB_TOKEN`: Created a repository secret containing my Docker Hub access token. This token is used to authenticate with Docker Hub during the GitHub Actions workflow and it should not be hardcoded in the codebase.

- `DOCKERHUB_USERNAME`: Created a repository variable containing my Docker Hub username, which is used to identify my Docker Hub account when pushing the image.

---

### 4. Created a GitHub Actions Workflow

Created a GitHub Actions workflow named `ci.yaml` inside the `.github/workflows` directory at the root of the repository. GitHub automatically detects workflow files placed in this directory and executes them.

```yaml
# Name of the GitHub Actions workflow
name: Build and push container image to Docker Hub

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

      # Step 3 - Set up Docker Buildx
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v4

      # Step 4 - Build the Docker image and push it to Docker Hub
      - name: Build and push
        uses: docker/build-push-action@v7
        with:
          # Specify the directory containing the Dockerfile and application
          context: ./cicd/task-1

          # Push the built image to Docker Hub
          push: true

          # Pushes the built image to Docker Hub with the `latest` tag.
          tags: ${{ vars.DOCKERHUB_USERNAME }}/python-app:latest
```
This workflow builds and pushes the container image to Docker Hub whenever code is pushed to the repository.

---

### 5. Successful Execution and Deployment

**GitHub Actions Workflow**

The GitHub Actions workflow executed successfully, completing all the configured steps without errors.

<img width="759" height="606" alt="task-1-workflow-successful" src="https://github.com/user-attachments/assets/f94d41f4-8c25-4153-8f4f-78b1622dae43" />

**Docker Hub Image**

The Docker image was successfully built and pushed to my Docker Hub repository with the `latest` tag.

<img width="899" height="641" alt="task-1-pushed-to-dockerhub" src="https://github.com/user-attachments/assets/217c2f1e-c328-4e2f-9b4f-05e17f8b62b0" />

---
## What I learnt 

**1. Using Repository Variables in GitHub Actions:** A repository variable can be referenced within a GitHub Actions workflow by writing `${{ vars.<variable_name>}}`

**2. Authenticating with Docker Hub:** The action `docker/login-action@v4` is used to authenticate with Docker Hub from a GitHub Actions workflow. It accepts a username and password as inputs. For Docker Hub authentication, the Docker Hub username and a personal access token can be provided instead of the account password.

**3. Building and pushing a Docker image to Docker Hub:** I've learnt how to use the action `docker/build-push-action@v7` to build a Docker image using a Dockerfile and push that image to Docker Hub directly from a GitHub Actions workflow.

---

## Issues I've solved

### 1. Nothing appeared in the Actions section of my GitHub repository

**Cause and Solution**

- I initially created the `.github/workflows` directory inside the `task-1` directory instead of the root directory of my repository.

- GitHub Actions only detects workflow files located in the `.github/workflows` directory at the root of the repository.

- To resolve the issue, I deleted the incorrectly placed `.github/workflows` directory and recreated it at the root of my repository.

**Result:** Once I moved the workflow file into the correct directory and pushed the changes to GitHub, GitHub Actions could detect the workflow and execute it.

### 2. Docker image build failed because the build context path could not be found

**Cause and Solution**

- The Docker image build failed because the specified build context path (`./cicd/task-1`) could not be found.

- The cause was that I had not included the repository checkout step in my GitHub Actions workflow. So GitHub Actions did not have access to the repository files needed for the build.

To resolve the issue, I added the following step before the Docker build step:

```yaml
   - name: checkout repository
     uses: actions/checkout@v6
```

**Result:** The `actions/checkout@v6` action downloads the repository contents into the GitHub Actions runner's workspace, making the files and directories available to subsequent workflow steps. 
Then the error was resolved.








