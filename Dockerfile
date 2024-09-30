FROM node:16.17.0-alpine as builder
WORKDIR /app
COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install
COPY . .
ARG TMDB_V3_API_KEY
ENV VITE_APP_TMDB_V3_API_KEY=393fd9e7c8eeb28d11e7c584d9ee166c
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"
RUN yarn build

FROM cgr.dev/chainguard/nginx:latest
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/dist .
EXPOSE 8080
ENTRYPOINT ["nginx", "-g", "daemon off;"]
