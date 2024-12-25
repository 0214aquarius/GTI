FROM alpine:3.14@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae AS builder

ENV BLUEBIRD_WARNINGS=0 \
  NODE_ENV=production \
  NODE_NO_WARNINGS=1 \
  NPM_CONFIG_LOGLEVEL=warn \
  SUPPRESS_NO_CONFIG_WARNING=true

RUN apk add --no-cache \
  nodejs \
  npm

WORKDIR /app

COPY package.json ./

RUN npm install --no-optional \
  && npm cache clean --force

COPY . .

FROM alpine:3.14@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae

ENV NODE_ENV=production

RUN apk add --no-cache \
  nodejs

WORKDIR /app

COPY --from=builder /app .

CMD ["node", "/app/app.js"]

EXPOSE 3000
