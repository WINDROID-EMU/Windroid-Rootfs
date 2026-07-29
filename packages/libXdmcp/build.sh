PKG_VER=1.1.5
SRC_URL=https://artfiles.org/x.org/pub/individual/lib/libXdmcp-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
DEPENDENCIES="xorgproto xorg-utils-macros"