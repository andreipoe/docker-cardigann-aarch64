FROM arm64v8/golang:1.10-alpine
MAINTAINER "Andrei Poenaru <andrei@poena.ru>"

# Set the cardigann version to install
ARG cardigann_ver=master

# Install build dependencies
RUN apk add --no-cache \
	--virtual=build-dependencies \
	gcc g++ git make \
	nodejs-npm \
	ca-certificates

# Build cardigann
# Step 1: setup the build 
WORKDIR /go
RUN mkdir -p /go/src/github.com/cardigann && \
	cd /go/src/github.com/cardigann/ && \
	git clone --depth 1 -b $cardigann_ver https://github.com/cardigann/cardigann.git && \
	cd cardigann && \
	make setup
	
# Step 2: build the web interface
WORKDIR /go/src/github.com/cardigann/cardigann/web
RUN npm install

# Step 3: build the go binary
WORKDIR /go/src/github.com/cardigann/cardigann
RUN make build && \
	make install

# Clean up build dependencies
RUN apk del --purge build-dependencies && \
	rm -rf /var/cache/apk/*

# Store the config files in a volmue
ENV CONFIG_DIR=/config
VOLUME "$CONFIG_DIR"

# Expose the default cardigann port
EXPOSE 5060

# Run the cardigann server
CMD ["cardigann", "server"]
