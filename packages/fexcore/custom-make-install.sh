mkdir -p $DESTDIR/$PREFIX/bin
mkdir -p $DESTDIR/$PREFIX/etc/fex-emu

if [ -f "Bin/FEXLoader" ]; then
    cp Bin/FEXLoader $DESTDIR/$PREFIX/bin/
elif [ -f "FEXLoader" ]; then
    cp FEXLoader $DESTDIR/$PREFIX/bin/
fi

if [ -f "Bin/FEXInterpreter" ]; then
    cp Bin/FEXInterpreter $DESTDIR/$PREFIX/bin/
elif [ -f "FEXInterpreter" ]; then
    cp FEXInterpreter $DESTDIR/$PREFIX/bin/
fi

if [ -f "Bin/FEXServer" ]; then
    cp Bin/FEXServer $DESTDIR/$PREFIX/bin/
elif [ -f "FEXServer" ]; then
    cp FEXServer $DESTDIR/$PREFIX/bin/
fi

cat << 'EOF' > $DESTDIR/$PREFIX/etc/fex-emu/Config.json
{
  "Config": {
    "SilentLog": 1,
    "TSOEnabled": 1,
    "MultiBlock": 1
  }
}
EOF

