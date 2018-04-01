FROM arm64v8/golang:1.10-alpine
MAINTAINER "Andrei Poenaru <andrei@poena.ru>"

# Set the cardigann version to install
ARG cardigann_ver=master

# Install build dependencies, build cardigann, then remove unneeded packages
RUN apk add --no-cache \
	--virtual=build-dependencies \
	gcc g++ git make \
	nodejs-npm \
	ca-certificates && \
    echo "------------Build cardigann" >&2 && \
    echo "------------Step 1: setup the build" >&2 && \ 
    mkdir -p /go/src/github.com/cardigann && \
	cd /go/src/github.com/cardigann/ && \
	git clone --depth 1 -b $cardigann_ver https://github.com/cardigann/cardigann.git && \
	cd cardigann && \
	make setup && \
    echo "------------Step 2: build the web interface" >&2 && \
    cd web && \
    npm install && \
    echo "------------Step 3: build the go binary" >&2 && \
    cd .. && \
    make build && \
	make install && \
    echo "------------Clean up build dependencies" >&2 && \
    apk del --purge build-dependencies && \
	rm -rf /var/cache/apk/* && \
    rm -rf /go/src/* && \
    rm -rf ~/.cache ~/.npm

# Store the config files in a volmue
ENV CONFIG_DIR=/config
VOLUME "$CONFIG_DIR"

# Expose the default cardigann port
EXPOSE 5060

# Run the cardigann server
CMD ["cardigann", "server"]
