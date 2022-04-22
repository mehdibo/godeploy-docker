#!/bin/sh

# We set env vars that should not change in this container
export SSH_PRIVATE_KEY=/etc/ssh_private_key
export SSH_KNOWN_HOSTS_FILE=/var/godeploy/KnownHosts

ATTEMPTS_LEFT_TO_REACH_AMQP=60
until [ $ATTEMPTS_LEFT_TO_REACH_AMQP -eq 0 ] || AMQP_ERROR=$(curl http://$AMQP_HOST:$AMQP_PORT/ 2>&1); do
        if [ $? -eq 1 ]; then
                # RabbitMQ is up
                break
        fi
        sleep 1
        ATTEMPTS_LEFT_TO_REACH_AMQP=$((ATTEMPTS_LEFT_TO_REACH_AMQP - 1))
        echo "Still waiting for AMQP to be reachable... $ATTEMPTS_LEFT_TO_REACH_AMQP attempts left."
done

if [ $ATTEMPTS_LEFT_TO_REACH_AMQP -eq 0 ]; then
        echo "AMQP is not reachable"
        exit 1
else
        echo "RabbitMQ is now reachable"
fi

/usr/bin/$1
