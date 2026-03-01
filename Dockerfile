FROM node:24-alpine

USER root

# Install build deps
RUN apk update && apk add --no-cache build-base gcc wget git make g++ python3 which

# Create non-root user
RUN adduser -s /bin/sh -S -D app

# Setup /app
RUN mkdir /app && chown -R app:app /app

USER app
WORKDIR /app

# Copy and prepare script
COPY --chown=app:app runner.sh /app/runner.sh
RUN chmod +x /app/runner.sh

# fix any potential CRLF
RUN sed -i 's/\r$//' /app/runner.sh

ENTRYPOINT ["/app/runner.sh"]
