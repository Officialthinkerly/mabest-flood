FROM golang:1.22-alpine AS build
RUN go install github.com/rakyll/hey@latest

FROM alpine:latest
RUN apk add --no-cache bash curl
COPY --from=build /go/bin/hey /usr/local/bin/hey
WORKDIR /app
COPY flood.sh login.txt ./
RUN chmod +x flood.sh
CMD ["/bin/bash", "/app/flood.sh"]