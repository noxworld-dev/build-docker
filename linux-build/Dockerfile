FROM i386/golang:bullseye
RUN apt update &&\
    apt install -y libsdl2-dev libopenal-dev libglew-dev build-essential

ENV CGO_CFLAGS_ALLOW (-fshort-wchar)|(-fno-strict-aliasing)|(-fno-strict-overflow)
ENV CGO_ENABLED 1
ENV GOARCH 386

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
