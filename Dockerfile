# Build stage
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o main -ldflags="-w -s" ./cmd/api/main.go

# Final stage
FROM scratch

WORKDIR /app

# Copy binary from builder stage
COPY --from=builder --link /app/main .

# Expose port
EXPOSE 8080

# Run the application
CMD ["./main"]