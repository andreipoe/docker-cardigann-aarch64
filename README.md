# docker-cardigann for aarch64

This is a Docker image for running [Cardigann](https://github.com/cardigann/cardigann) on AArch64.

## Obtaining the image

### Building manually

Since DockerHub does not support automatic builds from source for non-x86 architectures, the recommended way to obtain the image is to build it yourself:

```bash
git clone https://github.com/andreipoe/docker-cardigann-aarch64.git
cd docker-cardigann-aarch64
docker build --build-arg cardigann_ver=v1.10.1 -t andreipoe/cardigann-aarch64 .
```

The `cardigann_ver` build argument is a git _tree-ish_ specifying which version to build. It is recommended that you use the [latest release tag](https://github.com/cardigann/cardigann/releases). If this argument is not given, then `master` is used.

### From DockerHub

If you do not want to build the container image yourself, you can download a pre-built copy from [DockerHub](https://hub.docker.com/r/andreipoe/cardigann-aarch64/):

```bash
docker pull andreipoe/cardigann-aarch64
```

## Running the container

```bash
docker run -d --name=cardigann \
    --restart unless-stopped \
    -p 5060:5060 \
    -v /data/docker/cardigann/config:/config \
    andreipoe/cardigann-aarch64
```

Note that you can set the Cardigann port using the `-p <port>:5060` argument and the location where your configutation is stored with the `-v <path>:/config` argument.
