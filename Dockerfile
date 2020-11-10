FROM ubuntu:20.04

RUN apt update
RUN apt install -y git curl xz-utils sudo

# Create non-root user and install Nix
RUN useradd -m user
RUN mkdir -m 0755 /nix && chown user /nix
USER user
WORKDIR /home/user
RUN curl -L https://nixos.org/nix/install | sh

# Clone fork of clojupyter and try to run mvn2nix
RUN git clone https://github.com/thomasjm/clojupyter.git
WORKDIR /home/user/clojupyter
ENV PATH="/home/user/.nix-profile/bin:${PATH}"
RUN . /home/user/.nix-profile/etc/profile.d/nix.sh && \
  ./generate_nix_dependencies.sh
