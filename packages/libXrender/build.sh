PKG_VER=0.9.11
SRC_URL=https://artfiles.org/x.org/pub/individual/lib/libXrender-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-malloc0returnsnull"
DEPENDENCIES="xorgproto libX11"
