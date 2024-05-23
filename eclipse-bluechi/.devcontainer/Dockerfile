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

ARG GRPCURL_URL=https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_linux_$(arch).tar.gz

RUN mkdir /usr/bin/grpcurl.d && \
curl -sSL ${GRPCURL_URL} | tar -xvz --directory /usr/bin/grpcurl.d && \
ln /usr/bin/grpcurl.d/grpcurl /usr/bin/grpcurl
