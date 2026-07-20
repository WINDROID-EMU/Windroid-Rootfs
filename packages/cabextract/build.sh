PKG_VER=1.11
SRC_URL=https://www.cabextract.org.uk/cabextract-$PKG_VER.tar.gz
# O cabextract usa Autotools (./configure ), o gerador detecta isso automaticamente
# Passamos os argumentos necessários para o cross-compile
CONFIGURE_ARGS="--host=$TOOLCHAIN_TRIPLE --prefix=$PREFIX --with-external-libmspack=no"
CFLAGS="-O3 -fPIC"
