FROM node:24-alpine

USER root

RUN apk update && apk add --no-cache build-base gcc wget git make g++ python3 which

RUN addgroup -S app
RUN adduser -S -D -G app app

RUN mkdir /app && chown -R app:app /app

USER app
WORKDIR /app

COPY --chown=app:app runner.sh /app/runner.sh
RUN chmod +x /app/runner.sh

ENTRYPOINT ["/app/runner.sh"]