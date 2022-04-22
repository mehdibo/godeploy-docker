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