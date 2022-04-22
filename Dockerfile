FROM golang:1.18-alpine AS builder

ARG GODEPLOY_VERSION=v0.0.1-alpha

WORKDIR /opt/godeploy

RUN apk update && apk add git make &&  go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest

RUN git clone --depth 1 --branch ${GODEPLOY_VERSION} https://github.com/mehdibo/godeploy.git /opt/godeploy && \
    VERSION=${GODEPLOY_VERSION} make

FROM alpine:3.15

ENV APP_ENV=prod
ENV DB_PORT=5432
ENV AMQP_PORT=5672

COPY --from=builder /opt/godeploy/bin/console /usr/bin/console
COPY --from=builder /opt/godeploy/bin/consumer /usr/bin/consumer
COPY --from=builder /opt/godeploy/bin/server /usr/bin/server
COPY --from=builder /opt/godeploy/swagger-ui /var/godeploy/swagger-ui
COPY ./entrypoint.sh /entrypoint.sh

RUN apk update && apk add curl && adduser -s /bin/sh -D -h /var/godeploy godeploy && \
    chmod u=rwx,g=rx,o=rx /usr/bin/console /usr/bin/consumer /usr/bin/server && \
    touch /var/godeploy/KnownHosts && \
    chown godeploy: /var/godeploy/KnownHosts && \
    chmod u=rw,g=rw,o=r /var/godeploy/KnownHosts && \
    chmod u=rwx,g=rx,o=rx /entrypoint.sh

WORKDIR /var/godeploy
USER godeploy

CMD ["/entrypoint.sh", "server"]