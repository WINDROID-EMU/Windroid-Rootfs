mkdir -p $DESTDIR/$PREFIX/bin
mkdir -p $DESTDIR/$PREFIX/etc/fex-emu
mkdir -p $DESTDIR/$PREFIX/lib/wine/aarch64-unix
mkdir -p $DESTDIR/$PREFIX/lib/wine/aarch64-windows

# Binarios FEX
if [ -f "Bin/FEXInterpreter" ]; then
    cp -f Bin/FEXInterpreter $DESTDIR/$PREFIX/bin/
elif [ -f "FEXInterpreter" ]; then
    cp -f FEXInterpreter $DESTDIR/$PREFIX/bin/
fi

if [ -f "Bin/FEXServer" ]; then
    cp -f Bin/FEXServer $DESTDIR/$PREFIX/bin/
elif [ -f "FEXServer" ]; then
    cp -f FEXServer $DESTDIR/$PREFIX/bin/
fi

# FEXLoader launcher script com suporte a execucao ELF x86_64 via box64 no Android ARM64
cat << 'EOF' > $DESTDIR/$PREFIX/bin/FEXLoader
#!/bin/sh
export FEX_ROOTFS="${FEX_ROOTFS:-/data/data/com.windroid.emu/files/usr}"
export FEX_CONFIG_DIR="${FEX_CONFIG_DIR:-/data/data/com.windroid.emu/files/usr/etc/fex-emu}"

if [ "$1" = "--" ]; then
    shift
fi

BOX64_BIN=""
if command -v box64 >/dev/null 2>&1; then
    BOX64_BIN="$(command -v box64)"
fi

if [ -z "$BOX64_BIN" ] || [ ! -x "$BOX64_BIN" ]; then
    for candidate in /data/data/com.windroid.emu/files/packages/Box64*/files/usr/bin/box64; do
        if [ -x "$candidate" ]; then
            BOX64_BIN="$candidate"
            break
        fi
    done
fi

if [ -n "$BOX64_BIN" ] && [ -x "$BOX64_BIN" ]; then
    exec "$BOX64_BIN" "$@"
else
    exec "$@"
fi
EOF
chmod +x $DESTDIR/$PREFIX/bin/FEXLoader
ln -sf FEXLoader $DESTDIR/$PREFIX/bin/FEXInterpreter 2>/dev/null || true
ln -sf FEXLoader $DESTDIR/$PREFIX/bin/FEX 2>/dev/null || true

# Copia de bibliotecas WoW64 / ARM64EC caso geradas pelo build
find . -name "lib*fex*.so" -exec cp -f {} $DESTDIR/$PREFIX/lib/wine/aarch64-unix/ \; 2>/dev/null || true
find . -name "lib*fex*.dll" -exec cp -f {} $DESTDIR/$PREFIX/lib/wine/aarch64-windows/ \; 2>/dev/null || true

cat << 'EOF' > $DESTDIR/$PREFIX/etc/fex-emu/Config.json
{
  "Config": {
    "SilentLog": 1,
    "TSOEnabled": 1,
    "MultiBlock": 1,
    "X87ReducedPrecision": 1
  }
}
EOF
