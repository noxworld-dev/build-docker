FROM i386/debian:bookworm-slim

# Prerequisites for the appimagetool.
RUN apt update
RUN apt install -y zlib1g libfuse2

# Appimage generation scripts
COPY scripts/ /scripts/
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
