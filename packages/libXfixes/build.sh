PKG_VER=6.0.1
SRC_URL=https://artfiles.org/x.org/pub/individual/lib/libXfixes-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
DEPENDENCIES="xorgproto xorg-utils-macros libX11"
