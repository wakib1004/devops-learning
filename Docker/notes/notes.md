# Docker Notes

## Table of contents 


## Containers
A container is a unit of software that includes everything needed to run an application, such as the compiled code, runtime, system libraries and system tools.

**Why use Containers**

1. Move faster by deplying small units.
2. Use fewer resources
3. Fit more on the same host
4. Faster automation
5. Portability
6. Isolation (If one fails, it will not take the whole system down with it)


**Virtual Machines**
A virtual machine (VM) is a software-based computer that runs inside a real computer, with its own operating system and apps.

## VMs vs Containers

### Comparasion Table

| Virtual Machine | Container
| :--- | :--- |
| Large footprint | Lightweight |
| Slow to boot | Quick to start (No booting needed | 
| Ideal for long running tasks | Ideal for short lived tasks | 
|  | Portable (can run same way everywhere) | 

## Container Registry 

A centralised container repository where you deploy the container images (Like Github but for containers)

Docker has one called Docker Hub which provides public and private repositories

All major cloud providers (AWS, Azure, Google Cloud) have a container registry.

---

## What is Docker

Docker is a platform that provides:

- An open source container runtime
- Mac, Windows and Linux support
- Command line tool (to create and manage containers)
- "Dockerfile" file format for building container images.

## Docker basic commands

### Running and stopping

| Command | Description
| :--- | :--- |
| docker pull [imageName] | Pulls image from registry |
| docker run [imageName] -d | Run containers (detached mode) | 
| docker start [containerName] | Start stopped containers | 
| docker ps | List running containers |
| docker ps -a | List running and stopped containers | 
| docker stop [containerName] | Stop containers | 
| docker rm [containerName] | Remove containers  | 
| docker kill [containerName] | Kill containers | 
| docker image inspect [imageName] | Get image info | 

### How to write a dockerfile

```dockerfile

# 1) Base image - Always start with an already existing image
FROM ubuntu:latest

# 2) Copy a script from your project into the image
COPY hello.sh /hello.sh

# 3) Run this command during the build
RUN chmod +x /hello.sh

# 4) Default command when the container runs. 
CMD ["/hello.sh"]

#For command like echo "Hello", it would be CMD ["echo", "Hello"]

```

---

## **Volumes**

Containers normally lose all their data when they stop, so you usually don’t store persistent data inside containers.

A volume is a way to store data outside the container’s writable filesystem so it persists even after the container stops or is removed.

It maps a folder on the host to a directory inside the container.

### Volume commands cheat-sheet

| Command | Description
| :--- | :--- |
| docker create volume [volumeName] | Creates a new volume |
| docker volume ls | Lists the volume or volumes | 
| docker volume rm [volumeName] | Deletes the volume | 
| docker volume prune | Deletes all volumes not in mounted / not in use |
| docker volume inspect [volumeName] | Displays the volume info | 

---

## Docker Compose

Docker Compose allows you to define and run multi containers applications using a single YAML file.

### YAML file format

YAML is a way to serialize data so it's readable by humans.
It is used by Docker compose and Kubernetes.

```yaml

key: value
a_number_value: 100  # Note the space after the colon!

#Standard practice is 2 spaces for indentation
a_nested_map:
  key: value
  another_key: Another Value
  another_nested_map:
    hello: hello

#Lists are defined using a dash - followed by a space.
a_sequence:
  - Item 1
  - Item 2

```
YAML Lint can be used for flagging errors in your YAML.

### Docker compose file

```yaml

version: '3.9'   # Optional (defines compose file version)

services:
  webapi1:                     # Container name (hostname inside network)
    image: academy.azurecr.io/webapi1   # Image location
    ports:
      - '8081:80'              # Host:Container port (Listening port)
    restart: always

  webapi2: #Second container 
    image: academy.azurecr.io/webapi2
    ports:
      - '8082:80'
    restart: always

```

### FEATURES

### Docker Compose Cheat Sheet

| Command | Description
| :--- | :--- |
| docker compose build | Builds the image |
| docker compose start | Starts the containers | 
| docker compose stop | Stops the containers | 
| docker compose up -d | Build and start |
| docker compose ps | List what's running | 
| docker compose rm | Remove from memory |  
| docker compose down | Stop and remove | 
| docker compose logs | Get the logs |
| docker compose exec [container] bash | Run a command in a container | 

### Compose V2 - New Commands

| Command | Description
| :--- | :--- |
| docker compose --project-name test1 up -d | Run an instance as a project |
| docker compose -p test2 up -d | Shortcut for the one  above | 
| docker compose ls | List running projects | 
| docker compose cp [containerID]:[SRC_PATH]:[DEST_PATH] | copy files from the container |
| docker compose cp [SRC_PATH] [containerID]:[DEST_PATH] | copy files to the container |

---

## Definitions 

Runtime - what exceutes the program after it has been written.

System libraries - Ready‑made chunks of code your program can call to do specific tasks.

System tools - Software programs included with or provided for an operating system that help manage, maintain, configure a computer system.

Centralised Repository - Single, central location where all the project’s code and files are stored, and all team members commit (upload) and pull (download) changes from this one place.

ephemorous (short-lived) and stateless.
## Container Image 

Container images are read-only templates a container runtime uses to create a running container, it holds everything needed to run an application.

