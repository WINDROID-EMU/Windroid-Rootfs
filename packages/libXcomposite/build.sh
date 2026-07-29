PKG_VER=0.4.6
SRC_URL=https://artfiles.org/x.org/pub/individual/lib/libXcomposite-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE"
DEPENDENCIES="xorgproto xorg-utils-macros libX11 libXfixes"
