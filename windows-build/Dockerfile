FROM archlinux/archlinux:base-devel

ENV MAKEFLAGS -j8
ENV CGO_ENABLED 1

RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm git go multilib-devel
RUN	useradd -m builder
RUN	git clone --depth 1 -b go-cgo-gcc-parallelism-1.20.3 https://github.com/Evengard/go &&\
	cd go/src && ./make.bash
RUN pacman -R --noconfirm go
RUN	echo "builder ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder	
RUN sudo -u builder sh -c "cd &&\
		git clone https://aur.archlinux.org/yay-bin.git &&\
		cd yay-bin &&\
		makepkg -si --noconfirm &&\
		yay -S --noconfirm mingw-w64-glew mingw-w64-ldd mingw-w64-openal mingw-w64-sdl2"

ENV PATH=/go/bin:$PATH
ENV PKG_CONFIG_PATH /usr/i686-w64-mingw32/lib/pkgconfig/
ENV CGO_CFLAGS_ALLOW (-fshort-wchar)|(-fno-strict-aliasing)|(-fno-strict-overflow)
#ENV LD_LIBRARY_PATH /usr/i686-w64-mingw32/lib
#ENV C_INCLUDE_PATH /usr/i686-w64-mingw32/include
ENV GOARCH 386

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
