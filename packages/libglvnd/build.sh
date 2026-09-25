PKG_VER=1.7.0
SRC_URL=https://github.com/NVIDIA/libglvnd/archive/refs/tags/v$PKG_VER.tar.gz
MESON_ARGS="-Dtls=false -Degl=false -Dgles1=false -Dgles2=false -Dglx=disabled -Dx11=disabled"
CFLAGS="-I$PREFIX_DIR/include"
DEPENDENCIES=""
