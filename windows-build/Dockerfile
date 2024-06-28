FROM archlinux/archlinux:multilib-devel

ARG GO_VERSION="go1.21.5"
ENV MAKEFLAGS -j8
ENV CGO_ENABLED 1

COPY entrypoint.sh /entrypoint.sh

RUN pacman -Syu --noconfirm && pacman -S --noconfirm git go multilib-devel &&\
	useradd -m builder &&\
	git clone --depth 1 -b ${GO_VERSION} https://github.com/golang/go &&\
	cd go/src && ./make.bash && pacman -R --noconfirm go &&\
	echo "builder ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder
USER builder
RUN	cd &&\
	git clone https://aur.archlinux.org/yay-bin.git &&\
	cd yay-bin &&\
	makepkg -si --noconfirm &&\
	yay -S --noconfirm mingw-w64-glew mingw-w64-ldd mingw-w64-openal mingw-w64-sdl2

ENV PATH=/go/bin:$PATH
ENV PKG_CONFIG_PATH /usr/i686-w64-mingw32/lib/pkgconfig/
ENV CGO_CFLAGS_ALLOW (-fshort-wchar)|(-fno-strict-aliasing)|(-fno-strict-overflow)
#ENV LD_LIBRARY_PATH /usr/i686-w64-mingw32/lib
#ENV C_INCLUDE_PATH /usr/i686-w64-mingw32/include
ENV GOARCH 386

ENTRYPOINT /entrypoint.sh
