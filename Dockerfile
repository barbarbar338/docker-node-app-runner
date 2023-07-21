FROM arm64v8/node:18-alpine

RUN apk update && apk add build-base gcc wget git make g++ python3

WORKDIR /app
COPY . .

RUN yarn install
RUN yarn build

CMD ["yarn", "start"]
