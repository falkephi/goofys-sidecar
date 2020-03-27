FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y fuse wget && \
    wget https://github.com/kahing/goofys/releases/latest/download/goofys && \
    chmod 755 goofys

COPY run.sh /run.sh
ENTRYPOINT exec /run.sh
