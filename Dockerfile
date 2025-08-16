FROM golang:1.21-alpine3.18 as builder
RUN apk update && apk upgrade --available && sync
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -o /app/fsb -ldflags="-w -s" ./cmd/fsb

FROM scratch
COPY --from=builder /app/fsb /app/fsb

# Heroku provides $PORT as an env var
ENV PORT=8080
EXPOSE 8080

# Run your Go binary and bind to $PORT
CMD ["/app/fsb", "run"]
