# Use an official Ubuntu as a parent image
FROM ubuntu:latest
# Update packages and install necessary tools
RUN apt-get update && \
    apt-get install -y \
    curl \
    unzip \
    git \
    software-properties-common
# Install Homebrew
RUN mkdir -p /home/linuxbrew/.linuxbrew && \
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C /home/linuxbrew/.linuxbrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"
# Install dependencies for Homebrew
RUN apt-get install -y build-essential
# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Create a non-root user to run Homebrew
RUN useradd -m -s /bin/bash linuxbrew && \
    chown -R linuxbrew:linuxbrew /home/linuxbrew
# Switch to the linuxbrew user
USER linuxbrew
# Install tooling using Homebrew
RUN brew install terraform
RUN brew install tflint
# Verify installations
RUN terraform --version
RUN tflint --version
# Set working dir
WORKDIR /work
# Default command
CMD ["bash"]