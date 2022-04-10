FROM archlinux/archlinux:base-devel
RUN pacman -Syu --noconfirm &&\
	pacman -S --noconfirm git &&\
	useradd -m builder &&\
	echo "builder ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder &&\
	su builder -c "cd &&\
		git clone https://aur.archlinux.org/yay-bin.git &&\
		cd yay-bin &&\
		makepkg -si --noconfirm &&\
		yay -S --noconfirm mingw-w64-glew mingw-w64-ldd mingw-w64-openal mingw-w64-sdl2 go"

ENV PKG_CONFIG_PATH /usr/i686-w64-mingw32/lib/pkgconfig/
ENV CC_FOR_TARGET i686-w64-mingw32-gcc
ENV CGO_CFLAGS_ALLOW (-fshort-wchar)|(-fno-strict-aliasing)|(-fno-strict-overflow)
ENV LD_LIBRARY_PATH /usr/i686-w64-mingw32/lib
ENV CC i686-w64-mingw32-gcc
ENV CGO_ENABLED 1
ENV C_INCLUDE_PATH /usr/i686-w64-mingw32/include
ENV GOOS windows
ENV GOARCH 386

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
