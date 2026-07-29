PKG_VER=1.1.5
SRC_URL=https://artfiles.org/x.org/pub/individual/lib/libXxf86vm-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-malloc0returnsnull"
DEPENDENCIES="xorgproto libX11 libXext"
