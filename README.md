# Go Deploy Docker image
This is the official image for [Go Deploy](https://github.com/mehdibo/godeploy)

# Usage

To start the server run:
```sh
docker run --name godeploy -p 8080:8080 -d mehdibo/godeploy
```
These are the available environment variables:

 - `-e LISTEN_PORT=` Default: 8080
 - `-e APP_ENV=` Default: prod
 - `-e DB_HOST=`
 - `-e DB_USER=`
 - `-e DB_PASS=`
 - `-e DB_NAME=`
 - `-e DB_PORT=` Default: 5432
 - `-e AMQP_HOST=`
 - `-e AMQP_USER=`
 - `-e AMQP_PASS=`
 - `-e AMQP_PORT=` Default: 5672

Now it should be accessible via `http://localhost:8080`

To start the consumer run:

```sh
docker run --name godeploy-consumer ./ssh/private_key:/etc/ssh_private_key:ro -d mehdibo/godeploy consumer
```

An extra environemt variable exists for the consumer:
 - `-e SSH_PASSPHRASE=`

## Docker compose
To use it with a docker compose, check the [`docker-compose.yml`](https://github.com/mehdibo/godeploy-docker/blob/develop/docker-compose.yml) example file.

```yaml
version: "3.4"

services:
  database:
    image: postgres:14-alpine
    restart: unless-stopped
    environment:
      - POSTGRES_DB=godeploy
      - POSTGRES_PASSWORD=godeploy
      - POSTGRES_USER=godeploy
    volumes:
      - db_data:/var/lib/postgresql/data:rw

  rabbitmq:
    image: rabbitmq:3.9-alpine
    restart: unless-stopped
    volumes:
      - amqp_data:/var/lib/rabbitmq
  
  server:
    image: mehdibo/godeploy:latest
    restart: unless-stopped
    ports:
      - "80:8080"
    depends_on:
      - database
      - rabbitmq
    environment:
      #- APP_ENV=dev # Default is prod
      #- LISTEN_PORT=8080 # Default is 8080
      - DB_HOST=database
      - DB_USER=godeploy
      - DB_PASS=godeploy
      - DB_NAME=godeploy
      #- DB_PORT=5432 # Default is 5432
      - AMQP_HOST=rabbitmq
      - AMQP_USER=guest
      - AMQP_PASS=guest
      #- AMQP_PORT=5672 # Default is 5672
    
  consumer:
    image: mehdibo/godeploy:latest
    restart: unless-stopped
    depends_on:
      - database
      - rabbitmq
    environment:
      #- APP_ENV=dev # Default is prod
      - DB_HOST=database
      - DB_USER=godeploy
      - DB_PASS=godeploy
      - DB_NAME=godeploy
      #- DB_PORT=5432 # Default is 5432
      - AMQP_HOST=rabbitmq
      - AMQP_USER=guest
      - AMQP_PASS=guest
      #- AMQP_PORT=5672 # Default is 5672
      #- SSH_PASSPHRASE= # SSH private key passphrase if any
    volumes:
      - ./ssh_private_key:/etc/ssh_private_key:ro
    entrypoint: "/entrypoint.sh consumer"


volumes:
  db_data:
  amqp_data:
```