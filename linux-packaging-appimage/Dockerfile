FROM --platform=linux/386 debian:bookworm-slim

# Appimage generation scripts
COPY scripts/ /scripts/

# Prerequisites for the appimagetool. Marking scripts as executable
RUN apt update && apt upgrade -y && apt install -y zlib1g file wget &&\
	apt install -y libsdl2-dev libopenal-dev && chmod -v a+x /scripts/*.sh

COPY entrypoint.sh /entrypoint.sh
# ENV APPIMAGETOOL_RELEASE="13"
ENTRYPOINT /entrypoint.sh
