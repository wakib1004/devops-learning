#!/usr/bin/env python3
import os
from flask import Flask
import redis

app = Flask(__name__)

REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=0, decode_responses=True)

@app.route("/")
def welcome():
    return "Welcome to my website"

@app.route("/count")
def counter():
    visits = r.incr("visits")
    return f'This website has {visits} visits'

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
