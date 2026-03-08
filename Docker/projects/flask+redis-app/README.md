# Flask + Redis App
[![Docker](https://img.shields.io/badge/Built%20With-Docker-blue?logo=docker)](https://www.docker.com/)
[![Flask](https://img.shields.io/badge/Framework-Flask-black?logo=flask)](https://flask.palletsprojects.com/)
[![Redis](https://img.shields.io/badge/Database-Redis-red?logo=redis)](https://redis.io/)

## Demo GIF:
![chrome_Ddtw2DFn57-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/dc81382b-14ff-4b73-bbd7-c09ceebb243a)

A containerized Flask web application that shows number of page visits, using Redis as a database to store the visit counter.
The project demonstrates a multi-container architecture using Docker Compose, running the Flask application and Redis in separate containers. Data persistence is handled through a Docker volume to ensure state is maintained across container restarts.

---

## Features

- Flask web app container running locally on port 5000
- Redis container for view count storage with persistent volume
- Docker Compose for orchestration and network configuration

---

## Tech Stack

- Python 3
- Flask
- Redis
- Docker
- Docker Compose

---

## How It Works

- The Flask application processes incoming HTTP requests and shows the current number of page views.

- Redis keeps track of the counter and increases it every time the page is visited.

- The two containers interact over Docker’s internal network, with the Flask app connecting to Redis using the hostname redis (the service name).

- A Docker volume is used to store Redis data, ensuring data persists even if the containers are restarted or rebuilt.


## Setup

### 1. Clone the repository
```bash
git clone git@github.com:yourusername/flask+redis-app.git
cd flask+redis-app
```

### 2. Build and run the containers
```bash
docker-compose up -d
```

### 3. Open the app  
- Visit `http://localhost:5000` in your browser to view the welcome page.
- Visit `http://localhost:5000/count` in your browser to view the number of visits this page.

Each page refresh increments the counter stored in Redis.

---

## Environment Variables

Defined in `docker-compose.yml`:  
```yaml
REDIS_HOST=redis
```

This variable tells Flask the hostname of the Redis service within the Docker network.

---


## Project Structure

```
flask+redis-app/  
│  
├── app.py – Flask application  
├── Dockerfile – Build instructions for Flask container  
├── docker-compose.yml – Multi-container setup with Redis volume  
└── README.md  
```

