FROM ghcr.io/eclipse-ankaios/app-ankaios-dev:0.3.1
ARG TARGETARCH

RUN apt-get update && apt-get -y install \
    git \
    jq \
    # Add your development tools here ...
    # If you like to use Rust please uncomment the two following lines...
    # build-essential \
    # && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y \
    # Cleanup
    && rm -rf /var/lib/apt/lists/* \
    && curl -sL https://github.com/mikefarah/yq/releases/download/v4.42.1/yq_linux_${TARGETARCH} -o /usr/bin/yq \
    && chmod +x /usr/bin/yq

# Trust all repositories in this container
RUN git config --global --add safe.directory '*' \
    && echo "if [ -f /etc/bash_completion ] && ! shopt -oq posix; then\n . /etc/bash_completion \nfi" >> /root/.bashrc \
    && echo 'export PATH=$PATH:/workspaces/software-orchestration/scripts' >> /root/.bashrc

