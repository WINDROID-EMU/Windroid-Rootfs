PKG_VER=1.29.2
SRC_URL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-$PKG_VER.tar.xz
MESON_ARGS="-Dcairo=disabled -Dexamples=disabled -Dgdk-pixbuf=disabled -Doss=disabled "
# Removido -Daalib=disabled pois a opção não é mais reconhecida nesta versão
MESON_ARGS+="-Doss4=disabled -Dtests=disabled -Dv4l2=disabled"
LDFLAGS="-L$PREFIX/lib -landroid-shmem"
DEPENDENCIES="glib gst-plugins-base android-shmem"
