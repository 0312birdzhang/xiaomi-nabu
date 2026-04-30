FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
  docker.io \
  qemu-user-static \
  xz-utils \
  tar \
  e2fsprogs \
  fakeroot \
  || true

RUN docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

RUN mkdir -p /work
WORKDIR /work
CMD ["/bin/bash"]