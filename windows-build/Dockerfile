FROM archlinux/archlinux:base-devel

ENV MAKEFLAGS -j8
ENV CGO_ENABLED 1

RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf &&\
	pacman -Syu --noconfirm && pacman -S --noconfirm git go multilib-devel &&\
	useradd -m builder &&\
	git clone --depth 1 -b go1.21.5 https://github.com/golang/go &&\
	cd go/src && ./make.bash && pacman -R --noconfirm go &&\
	echo "builder ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder	&&\
	sudo -u builder sh -c "cd &&\
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
