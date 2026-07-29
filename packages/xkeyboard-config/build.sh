PKG_VER=2.41
SRC_URL=https://artfiles.org/x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-$PKG_VER.tar.xz
MESON_ARGS="-Dxkb-base=$PREFIX/share/X11/xkb -Dcompat-rules=true -Dxorg-rules-symlinks=false"
