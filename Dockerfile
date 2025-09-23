FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    fortune-mod \
    fortunes \
    cowsay \
    netcat-openbsd \
    tini \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/games:${PATH}"

WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

EXPOSE 4499

# Use tini as the entrypoint
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/app/wisecow.sh"]

