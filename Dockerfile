FROM golang:1.12.5 as builder
WORKDIR /code
ADD go.mod go.sum /code/
RUN go mod download
ADD . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-extldflags '-static'" -o /flog .

FROM alpine:3.9
RUN apk --update upgrade && apk add --no-cache ca-certificates
RUN addgroup -g 1000 -S flog && adduser -u 1000 -S flog -G flog
USER flog
COPY --from=builder /flog /usr/bin/flog
CMD ["flog"]
