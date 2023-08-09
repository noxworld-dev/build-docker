FROM --platform=linux/386 debian:bookworm-slim

# Prerequisites for the appimagetool.
RUN apt update
RUN apt upgrade -y
RUN apt install -y zlib1g file wget
RUN apt install -y libsdl2-dev libopenal-dev

# Appimage generation scripts
COPY scripts/ /scripts/
COPY entrypoint.sh /entrypoint.sh
# ENV PATH=/usr/sbin:$PATH
ENTRYPOINT /entrypoint.sh
