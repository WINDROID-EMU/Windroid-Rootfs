PKG_VER=1.17.0
SRC_URL=https://artfiles.org/x.org/pub/individual/lib/libxcb-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
DEPENDENCIES="xorgproto libXau libXdmcp xcb-proto"
