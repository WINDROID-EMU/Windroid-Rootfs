PKG_VER="10.1-esync-xinput-dinput"
PKG_CATEGORY="Wine"
PKG_PRETTY_NAME="Wine ($PKG_VER)"
PKG_DOWNLOADABLE=1

BLACKLIST_ARCH=aarch64

GIT_URL="${LOCAL_WINE_SRC:-$INIT_DIR/../Windroid-wine}"
GIT_COMMIT="93dec5c4c7244f69bf82d973189d2c83da3237ff"
HOST_BUILD_CONFIGURE_ARGS="--enable-win64 --without-x"
HOST_BUILD_FOLDER="$INIT_DIR/workdir/$package/wine-tools"
HOST_BUILD_MAKE="make -j $(nproc) __tooldeps__ nls/all"
OVERRIDE_PREFIX="$(realpath $PREFIX/../wine)"
CONFIGURE_ARGS="--enable-archs=i386,x86_64 \
				--host=$TOOLCHAIN_TRIPLE \
				--with-wine-tools=$INIT_DIR/workdir/$package/wine-tools \
				--prefix=$OVERRIDE_PREFIX \
				--without-oss \
				--disable-winemenubuilder \
				--disable-win16 \
				--disable-tests \
				--with-x \
				--x-libraries=$PREFIX/lib \
				--x-includes=$PREFIX/include \
				--with-pulse \
				--with-gstreamer \
				--with-opengl \
				--with-gnutls \
				--with-mingw=gcc \
				--with-xinput \
				--with-xinput2 \
				--enable-nls \
				--without-xshm \
				--without-xxf86vm \
				--without-osmesa \
				--without-usb \
				--without-sdl \
				--without-cups \
				--without-netapi \
				--without-pcap \
				--without-gphoto \
				--without-v4l2 \
				--without-pcsclite \
				--without-wayland \
				--without-opencl \
				--without-dbus \
				--without-sane \
				--without-udev \
				--without-capi"

DEPENDENCIES="libX11 libXext libXcomposite libXrender libXcursor libXrandr libXxf86vm libXinerama libXfixes libXi Vulkan-Headers Vulkan-Loader libglvnd pulseaudio freetype libgnutls gstreamer gst-plugins-base gst-plugins-ugly gst-plugins-good gst-plugins-bad cabextract"
