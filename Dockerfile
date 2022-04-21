FROM golang:1.18-bullseye as build

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Move to working directory /build
WORKDIR /build

# Copy and download dependency using go mod
COPY go.mod .
COPY go.sum .
RUN go mod download

# Copy the code into the container
COPY . .

# Build the application
RUN go build -o ssosync .

FROM alpine

COPY --from=build /build/ssosync /usr/local/bin/ssosync

# Command to run when starting the container
ENTRYPOINT [ "/usr/local/bin/ssosync" ]
