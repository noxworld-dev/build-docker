FROM --platform=linux/386 debian:bookworm-slim

ENV APPIMAGETOOL_RELEASE="13"
ENV APPIMAGETOOL_FOLDER="/usr/bin"
# Appimage generation scripts
COPY scripts/ /scripts/

# Prerequisites for the appimagetool. Marking scripts as executable
RUN apt update && apt upgrade -y && apt install -y zlib1g file wget &&\
	apt install -y libsdl2-dev libopenal-dev && chmod -v a+x /scripts/*.sh &&\
	wget -q --show-progress  -O "$APPIMAGETOOL_FOLDER/appimagetool-$APPIMAGETOOL_RELEASE.AppImage" "https://github.com/AppImage/AppImageKit/releases/download/$APPIMAGETOOL_RELEASE/appimagetool-i686.AppImage" &&\
	chmod -v +x "$APPIMAGETOOL_FOLDER/appimagetool-$APPIMAGETOOL_RELEASE.AppImage"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
