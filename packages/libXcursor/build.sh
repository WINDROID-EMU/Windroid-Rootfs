PKG_VER=1.2.2
SRC_URL=https://artfiles.org/x.org/pub/individual/lib/libXcursor-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-malloc0returnsnull"
DEPENDENCIES="xorgproto xorg-utils-macros libX11 libXfixes libXrender"
