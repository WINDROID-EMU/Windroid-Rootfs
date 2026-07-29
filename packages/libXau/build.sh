PKG_VER=1.0.11
SRC_URL=https://artfiles.org/x.org/pub/individual/lib/libXau-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
DEPENDENCIES="xorgproto"