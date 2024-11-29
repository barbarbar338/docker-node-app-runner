FROM node:alpine

USER root

# Install dependencies
RUN apk update && apk add --no-cache build-base gcc wget git make g++ python3 which

# Create runner user
RUN adduser -s $(which bash) -S -D app

# Set working directory
RUN mkdir /app
RUN chown -R app /app

# Set user
USER app

# Set working directory
WORKDIR /app

# Copy runner.sh
COPY --chown=app:app runner.sh /app/runner.sh
RUN chmod +x /app/runner.sh

# Start runner
ENTRYPOINT ["/app/runner.sh"]

