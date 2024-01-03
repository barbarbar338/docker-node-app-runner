FROM node:18-alpine

USER root

# Install dependencies
RUN apk update && apk add --no-cache build-base gcc wget git make g++ python3

# Create runner user
RUN adduser --shell $(which bash) --disabled-password runner

# Set working directory
RUN mkdir /app
RUN chown -R runner /app

# Set user
USER runner

# Set working directory
WORKDIR /app

# Copy runner.sh
COPY --chown=runner:runner ./runner.sh /app/runner.sh
RUN chmod +x /app/runner.sh

# Start runner
ENTRYPOINT ["/app/runner.sh"]

