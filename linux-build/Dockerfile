FROM --platform=linux/386 debian:bookworm-slim

ARG GO_VERSION="1.22.8"
ARG GO_HASH="0c8e9f824bf443f51e06ac017b9ae402ea066d761b309d880dbb2ca5793db8a2"
ENV MAKEFLAGS=-j8
ENV GOHOSTARCH=386
ENV CGO_ENABLED=1
ENV GOARCH=386

RUN apt-get update &&\
    apt-get install -y libsdl2-dev libopenal-dev libglew-dev build-essential git wget &&\
	apt-get autoremove -y && apt-get clean -y cache

ADD --checksum=sha256:${GO_HASH} https://go.dev/dl/go${GO_VERSION}.linux-${GOARCH}.tar.gz /go.tar.gz
RUN tar -xzf go.tar.gz && rm go.tar.gz

ENV CGO_CFLAGS_ALLOW=(-fshort-wchar)|(-fno-strict-aliasing)|(-fno-strict-overflow)
ENV PATH=/go/bin:$PATH

RUN go version

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
