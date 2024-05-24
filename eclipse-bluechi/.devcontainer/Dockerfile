# /********************************************************************************
# * Copyright (c) 2024 Leonardo Rossetti <lrossett@redhat.com>
# *
# * This program and the accompanying materials are made available under the 2
# * terms of the Apache License 2.0 which is available at
# * https://www.apache.org/licenses/LICENSE-2.0.txt.
# *
# * SPDX-License-Identifier: Apache-2.0
# *
# * Contributors: 1
# *   Leonardo Rossetti - file creation
# ********************************************************************************/
FROM quay.io/centos-sig-automotive/autosd:latest

ARG TARGETARCH

# Based on the target architecture, download the correct grpcurl binary
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        GRPCURL_URL="https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_linux_x86_64.tar.gz"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        GRPCURL_URL="https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_linux_arm64.tar.gz"; \
    else \
        echo "Unsupported architecture"; \
        exit 1; \
    fi; \
        mkdir /usr/bin/grpcurl.d && \
        curl -sSL ${GRPCURL_URL} | tar -xvz --directory /usr/bin/grpcurl.d && \
        ln /usr/bin/grpcurl.d/grpcurl /usr/bin/grpcurl

RUN mkdir /usr/bin/grpcurl.d && \
curl -sSL ${GRPCURL_URL} | tar -xvz --directory /usr/bin/grpcurl.d && \
ln /usr/bin/grpcurl.d/grpcurl /usr/bin/grpcurl
