FROM dockcross/linux-armv7

MAINTAINER Artur Balanuta ""

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y git ruby2.3 ruby2.3-dev rubygems:any && \
    gem install --no-ri --no-rdoc fpm && \
    rm -rf /var/lib/apt/lists/*

ENV BUILD_FOLDER /build

WORKDIR ${BUILD_FOLDER}

#CMD ["/bin/bash", "-c", "make", "-f", "${BUILD_FOLDER}/Makefile"]
# CMD ["make", "clean"]