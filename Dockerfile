FROM alpine:latest

RUN apk update && \
    apk add git openssh-client rsync

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]