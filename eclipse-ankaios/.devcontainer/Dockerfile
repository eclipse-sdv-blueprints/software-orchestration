FROM ghcr.io/eclipse-ankaios/app-ankaios-dev:0.5.0
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

# Allow Ankaios log files to be written by root and ankaios user
RUN groupadd anklogs \
    && usermod -aG anklogs ankaios \
    && usermod -aG anklogs root \
    && mkdir -p /var/log/ankaios \
    && chown -R root:anklogs /var/log/ankaios \
    && sudo chmod -R 770 /var/log/ankaios

# work in insecure mode for experimenting with Ankaios in the dev container
RUN echo 'export ANKAGENT_INSECURE=true' | tee -a /root/.bashrc /home/ankaios/.bashrc \
    && echo 'export ANKSERVER_INSECURE=true' | tee -a /root/.bashrc /home/ankaios/.bashrc \
    && echo 'export ANK_INSECURE=true' | tee -a /root/.bashrc /home/ankaios/.bashrc

# Trust all repositories in this container
RUN git config --global --add safe.directory '*' \
    && echo "if [ -f /etc/bash_completion ] && ! shopt -oq posix; then . /etc/bash_completion; fi" | tee -a /root/.bashrc /home/ankaios/.bashrc \
    && echo 'export PATH=$PATH:/workspaces/software-orchestration/scripts' | tee -a /root/.bashrc /home/ankaios/.bashrc \
    # enable shell completion for ank cli
    && echo "if command -v ank &> /dev/null; then source <(COMPLETE=bash ank); fi" | tee -a /root/.bashrc /home/ankaios/.bashrc

