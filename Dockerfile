FROM scratch

ARG APP_NAME=mymainappforlab

WORKDIR /app

COPY ${APP_NAME} /app/main

EXPOSE 8080

CMD ["./main"]
