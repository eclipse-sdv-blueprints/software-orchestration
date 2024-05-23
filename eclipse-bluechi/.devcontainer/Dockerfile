FROM quay.io/centos-sig-automotive/autosd:latest

ARG GRPCURL_URL=https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_linux_x86_64.tar.gz

RUN mkdir /usr/bin/grpcurl.d && \
curl -sSL ${GRPCURL_URL} | tar -xvz --directory /usr/bin/grpcurl.d && \
ln /usr/bin/grpcurl.d/grpcurl /usr/bin/grpcurl
