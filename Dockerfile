FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        netcat \
        fortune-mod \
        cowsay \
        fortunes && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/games:${PATH}"

WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

# Copy your server script into the container
COPY wisecow.sh /app/wisecow.sh

# Make it executable
RUN chmod +x /app/wisecow.sh

# Expose the service port
EXPOSE 4499

# Run the script
CMD ["/app/wisecow.sh"]
