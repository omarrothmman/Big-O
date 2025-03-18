FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install bash (includes rbash)
RUN apt update && apt install -y --no-install-recommends \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Create restricted user
RUN useradd -m -s /bin/rbash restricted_user

# Set up restricted environment
RUN mkdir -p /home/restricted_user/bin && \
    ln -s /bin/echo /home/restricted_user/bin/echo && \
    echo 'export PATH=$HOME/bin' >> /home/restricted_user/.bashrc && \
    echo 'set -f' >> /home/restricted_user/.bashrc

# Create flag file
RUN echo "BAU{secure_jail_escape}" > /home/restricted_user/flag.txt && \
    chown restricted_user:restricted_user /home/restricted_user/flag.txt && \
    chmod 400 /home/restricted_user/flag.txt

# Single-step permission management
RUN chmod +x /bin/chmod && \
    chmod u+x /bin/bash /bin/rbash /bin/echo && \
    find /bin /usr/bin /sbin /usr/sbin -type f \
        ! -name "bash" \
        ! -name "rbash" \
        ! -name "echo" \
        ! -name "chmod" \
        -exec chmod a-rwx {} + && \
    chmod a-rwx /bin/chmod

USER restricted_user
WORKDIR /home/restricted_user

CMD ["/bin/rbash"]
