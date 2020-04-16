# Deendemy

> A simple app.

## Method 1: Docker Build and Run Setup

To Install all system requirements and run app:

- Install Docker
- ```$ docker-compose up --build```
- Run API Server on port `3000` e.g. [`http://127.0.01:3000`]
- Run Mailcatcher UI in development on port `1080` e.g. [`http://127.0.0.1:1080`]

To Run Rspec Test:

- ```$ docker-compose run -e "RAILS_ENV=test" deendemy_api rspec -f d```

To Run Logs in Development:

- ```$ docker-compose run deendemy_api tail -f log/development.log```
