FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
  docker.io \
  qemu-user-static \
  xz-utils \
  tar \
  e2fsprogs \
  fakeroot \
  || true

RUN mkdir -p /work
WORKDIR /work
CMD ["/bin/bash"]