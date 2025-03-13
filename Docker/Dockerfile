FROM ubuntu:20.04

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt update && apt install -y \
    bash \
    sudo \
    && apt clean

# Create a restricted user
RUN useradd -ms /bin/bash restricted_user && \
    echo "restricted_user:password" | chpasswd && \
    usermod -aG sudo restricted_user

# Allow restricted_user to run sudo without a password
RUN echo "restricted_user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/restricted_user

# Remove all commands in /bin except for echo
RUN find /bin -type f ! -name 'echo' -exec rm -f {} \;

# Re-create /bin/sh symlink to ensure it's available
RUN ln -sf /bin/bash /bin/sh

# Set up a custom shell script to intercept deleted commands
RUN echo '#!/bin/bash\n\
if ! command -v "$1" &> /dev/null; then\n\
    echo "Command $1 is restricted and cannot be used.";\n\
    exit 1;\n\
else\n\
    "$@";\n\
fi' > /home/restricted_user/run.sh

# Make the custom script executable
RUN chmod +x /home/restricted_user/run.sh

# Restrict PATH to only include allowed commands: create a bin directory and link echo there
RUN mkdir /home/restricted_user/bin && ln -s /bin/echo /home/restricted_user/bin/echo

# Modify .bashrc to restrict PATH and create aliases for common commands
# Modify .bashrc to restrict PATH, create aliases, and block . and source
RUN echo 'export PATH=/home/restricted_user/bin:$PATH' >> /home/restricted_user/.bashrc && \
    echo 'alias ls="/home/restricted_user/run.sh ls"' >> /home/restricted_user/.bashrc && \
    echo 'alias cat="/home/restricted_user/run.sh cat"' >> /home/restricted_user/.bashrc && \
    echo 'alias head="/home/restricted_user/run.sh head"' >> /home/restricted_user/.bashrc && \
    echo 'alias tail="/home/restricted_user/run.sh tail"' >> /home/restricted_user/.bashrc && \
    echo 'alias nano="/home/restricted_user/run.sh nano"' >> /home/restricted_user/.bashrc && \
    echo '.() { echo "Command . is restricted and cannot be used."; return 1; }' >> /home/restricted_user/.bashrc && \
    echo 'source() { echo "Command source is restricted and cannot be used."; return 1; }' >> /home/restricted_user/.bashrc

# Create the flag file with your flag and set appropriate permissions
RUN echo 'QkFVezNjaDBfMXNfNGxsX3kwdV9uMzNkfQ==' > /home/restricted_user/flag.txt && \
    chown restricted_user:restricted_user /home/restricted_user/flag.txt && chmod 444 /home/restricted_user/flag.txt

# Set the default shell for the user to restricted bash
RUN usermod -s /bin/rbash restricted_user

USER restricted_user
WORKDIR /home/restricted_user

# Start a restricted shell
CMD ["rbash"]

