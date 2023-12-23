FROM i386/debian:bookworm-slim

ENV MAKEFLAGS -j8
ENV GOHOSTARCH 386
ENV CGO_ENABLED 1
ENV GOARCH 386

RUN apt-get update &&\
    apt-get install -y libsdl2-dev libopenal-dev libglew-dev build-essential golang git &&\
	git clone --depth 1 -b go1.21.5 https://github.com/golang/go &&\
	cd go/src && ./make.bash && apt-get remove -y golang && apt-get autoremove -y && apt-get clean -y cache

ENV CGO_CFLAGS_ALLOW (-fshort-wchar)|(-fno-strict-aliasing)|(-fno-strict-overflow)
ENV PATH=/go/bin:$PATH

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
