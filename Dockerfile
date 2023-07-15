FROM ubuntu:latest

WORKDIR /app

RUN apt update && apt upgrade -y && apt install -y git make gcc g++ python3 python3-pip curl

RUN curl -sL https://deb.nodesource.com/setup_18.x -o /tmp/nodesource_setup.sh
RUN chmod +x /tmp/nodesource_setup.sh
RUN bash /tmp/nodesource_setup.sh
RUN apt install nodejs

COPY runner.sh runner.sh

RUN chmod +x runner.sh

ENTRYPOINT ["/app/runner.sh"]
