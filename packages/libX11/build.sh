PKG_VER=1.8.13
SRC_URL=https://artfiles.org/x.org/pub/individual/lib/libX11-$PKG_VER.tar.xz
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE host_alias=$TOOLCHAIN_TRIPLE --enable-malloc0returnsnull"
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
DEPENDENCIES="xorgproto libxcb xtrans xorg-utils-macros android-shmem"
