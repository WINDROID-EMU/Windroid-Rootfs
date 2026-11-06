#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "============================================================"
echo "  WINDROID: Compilação do Wine 10.1 e Montagem do RootFS"
echo "============================================================"

# 1. Configurar variáveis de ambiente e ferramentas locais
export PATH="/home/anthero/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export BISON_PKGDATADIR="/home/anthero/.local/usr/share/bison"
export M4="/home/anthero/.local/bin/m4"

# 2. Verificar dependências
for tool in bison flex m4 make bwrap tar xz; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "ERRO: Ferramenta '$tool' não encontrada no PATH."
        exit 1
    fi
done

# 3. Garantir cache do NDK e MinGW
if [ ! -d "$SCRIPT_DIR/cache/android-ndk" ]; then
    if [ -d "/home/anthero/Android/Sdk/ndk/26.3.11579264" ]; then
        echo "Linkando Android NDK local para cache/android-ndk..."
        mkdir -p "$SCRIPT_DIR/cache"
        ln -sfn "/home/anthero/Android/Sdk/ndk/26.3.11579264" "$SCRIPT_DIR/cache/android-ndk"
    fi
fi

# 4. Criar diretório raiz simulado com /data, /windroid e symlinks merged-usr para o bubblewrap
GUEST_ROOT="/tmp/windroid_build_root"
rm -rf "$GUEST_ROOT"
mkdir -p "$GUEST_ROOT"
(
    cd "$GUEST_ROOT"
    ln -sfn usr/bin bin
    ln -sfn usr/sbin sbin
    ln -sfn usr/lib lib
    ln -sfn usr/lib64 lib64
    mkdir -p usr etc home root tmp var run media dev proc windroid data/data/com.windroid.emu/files/usr
)

# 5. Forçar rebuild do Wine apagando os artefatos anteriores de Wine em built-pkgs
echo ""
echo "-> Preparando compilação do Wine a partir do repositório local..."
rm -f built-pkgs/wine-*.rat built-pkgs/wine-*.commit built-pkgs/wine-*.isDownloadable
rm -rf workdir/wine

# 6. Executar build-all.sh para x86_64 usando bwrap para prover /data e /windroid (sem espaços)
echo ""
echo "-> Executando build-all.sh (x86_64) no ambiente Bubblewrap..."

bwrap --bind "$GUEST_ROOT" / \
      --bind "$SCRIPT_DIR/.." /windroid \
      --bind /usr /usr \
      --bind /etc /etc \
      --bind /home /home \
      --bind /var /var \
      --bind /tmp /tmp \
      --ro-bind /run /run \
      --dev-bind /dev /dev \
      --proc /proc \
      bash -c '
        export PATH="/home/anthero/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        export PKG_CONFIG_PATH="/home/anthero/.local/lib/pkgconfig"
        export BISON_PKGDATADIR="/home/anthero/.local/usr/share/bison"
        export M4="/home/anthero/.local/bin/m4"
        export REBUILD_PACKAGES="wine"
        cd /windroid/Windroid-Rootfs
        ./build-all.sh x86_64
      '

echo ""
echo "-> Verificando pacote do Wine compilado:"
ls -lh built-pkgs/wine-*.rat

# 7. Executar create-rootfs-rat.sh para aarch64
echo ""
echo "-> Montando o pacote RootFS final para aarch64..."

bwrap --bind "$GUEST_ROOT" / \
      --bind "$SCRIPT_DIR/.." /windroid \
      --bind /usr /usr \
      --bind /etc /etc \
      --bind /home /home \
      --bind /var /var \
      --bind /tmp /tmp \
      --ro-bind /run /run \
      --dev-bind /dev /dev \
      --proc /proc \
      bash -c '
        export PATH="/home/anthero/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        export BISON_PKGDATADIR="/home/anthero/.local/usr/share/bison"
        export M4="/home/anthero/.local/bin/m4"
        cd /windroid/Windroid-Rootfs
        ./create-rootfs-rat.sh aarch64
      '

echo ""
echo "============================================================"
echo "  Compilação e Montagem Concluídas com Sucesso!"
echo "============================================================"
echo "Artefatos gerados:"
ls -lh built-pkgs/wine-*.rat 2>/dev/null || true
ls -lh Windroid-RootFS-*-aarch64.rat 2>/dev/null || true
ls -lh Wine-Utils-*-any.rat 2>/dev/null || true

# Limpeza
rm -rf "$GUEST_ROOT"
