# syntax=docker/dockerfile:1.7
FROM ubuntu

WORKDIR /workspace

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y  \
      bash \
      cmake \
      g++ \
      flex \
      bison 

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN sed -i 's/\r$//' /usr/local/bin/docker-entrypoint.sh \
      && chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["test"]