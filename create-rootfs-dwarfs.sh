#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Specify Architecture for Building RootFS."
  exit 0
fi

if [ "$1" != "aarch64" ] && [ "$1" != "x86_64" ]; then
  echo "Invalid Architecture Specified, Available 'aarch64' and 'x86_64'"
  exit 0
fi

export PREFIX=/data/data/com.windroid.emu/files/usr
export INIT_DIR=$PWD
export ARCH=$1
export GIT_SHORT_SHA=$(git rev-parse --short HEAD)

# Auto-increment version for RootFS
VERSION_FILE="$INIT_DIR/.rootfs-version"
if [ -f "$VERSION_FILE" ]; then
  CURRENT_VERSION=$(cat "$VERSION_FILE")
else
  CURRENT_VERSION=10
fi
NEXT_VERSION=$((CURRENT_VERSION + 1))
echo $NEXT_VERSION > "$VERSION_FILE"
export ROOTFS_VERSION="(V$NEXT_VERSION)"

if [ ! -d "$INIT_DIR/built-pkgs" ]; then
  echo "built-pkgs: Don't Exist. Run 'build-all.sh' for generate the needed libs for creating a rootfs for MiceWine."
  exit 0
fi

export ROOTFS_PKGS=$(find "$INIT_DIR/built-pkgs" \( -name "*$ARCH*.rat" -o -name "*$ARCH*.dwarfs" \) | sort)
export WINE_PKG=$(find "$INIT_DIR/built-pkgs" \( -name "*wine*.rat" -o -name "*wine*.dwarfs" \))
export WINE_UTILS_PKG="$INIT_DIR/Wine-Utils-($GIT_SHORT_SHA)-any.dwarfs"

if [ ! -f "$WINE_UTILS_PKG" ] && [ -f "$INIT_DIR/Wine-Utils-($GIT_SHORT_SHA)-any.rat" ]; then
  WINE_UTILS_PKG="$INIT_DIR/Wine-Utils-($GIT_SHORT_SHA)-any.rat"
fi

if [ ! -f "$WINE_UTILS_PKG" ]; then
  $INIT_DIR/tools/download-external-dependencies.sh
  if command -v mkdwarfs &> /dev/null; then
    $INIT_DIR/tools/create-dwarfs-pkg.sh "Wine-Utils" "Wine Utils" "" "any" "($GIT_SHORT_SHA)" "wine-utils" "$INIT_DIR/wine-utils" "$INIT_DIR"
    WINE_UTILS_PKG="$INIT_DIR/Wine-Utils-($GIT_SHORT_SHA)-any.dwarfs"
  else
    $INIT_DIR/tools/create-rat-pkg.sh "Wine-Utils" "Wine Utils" "" "any" "($GIT_SHORT_SHA)" "wine-utils" "$INIT_DIR/wine-utils" "$INIT_DIR"
    WINE_UTILS_PKG="$INIT_DIR/Wine-Utils-($GIT_SHORT_SHA)-any.rat"
  fi
fi

ROOTFS_PKGS+=" $WINE_UTILS_PKG"

if [ -n "$WINE_PKG" ]; then
  ROOTFS_PKGS+=" $WINE_PKG"
else
  echo "Warning, Wine Not Found."
fi

resolvePath()
{
  if [ -f "$1" ]; then
    echo "$1"
  elif [ -f "$INIT_DIR/$1" ]; then
    echo "$INIT_DIR/$1"
  fi
}

getElementFromHeader()
{
  echo "$(cat pkg-header | head -n $1 | tail -n 1 | cut -d "=" -f 2)"
}

export RAND_VAL=$RANDOM

mkdir -p /tmp/$RAND_VAL

cd /tmp/$RAND_VAL

mkdir -p "vulkanDrivers"
mkdir -p "adrenoTools"
mkdir -p "box64"
mkdir -p "wine"

touch new_makeSymlinks.sh

for i in $ROOTFS_PKGS; do
  resolvedPath=$(resolvePath "$i")
  pkgBaseName=$(basename "$i")
  isOptName=$(echo "$pkgBaseName" | sed "s/\.dwarfs/\.isOptional/g" | sed "s/\.rat/\.isOptional/g")

  if [ -n "$resolvedPath" ] && [ ! -f "$INIT_DIR/built-pkgs/$isOptName" ]; then
    echo "Extracting '$pkgBaseName'..."

    if [[ "$resolvedPath" == *.dwarfs ]]; then
      if command -v dwarfsextract &> /dev/null; then
        dwarfsextract -i "$resolvedPath" -o . --pattern pkg-header
      else
        echo "Error: dwarfsextract tool is required to extract .dwarfs packages."
        exit 1
      fi
    else
      tar -xf "$resolvedPath" pkg-header
    fi

    packageCategory=$(getElementFromHeader 2)

    if [ "$packageCategory" == "VulkanDriver" ]; then
      cp -f "$resolvedPath" "vulkanDrivers"
    elif [ "$packageCategory" == "Box64" ]; then
      cp -f "$resolvedPath" "box64"
    elif [ "$packageCategory" == "Wine" ]; then
      cp -f "$resolvedPath" "wine"
    elif [ "$packageCategory" == "AdrenoTools" ]; then
      cp -f "$resolvedPath" "adrenoTools"
    else
      if [[ "$resolvedPath" == *.dwarfs ]]; then
        dwarfsextract -i "$resolvedPath" -o .
      else
        tar -xf "$resolvedPath"
      fi
    fi

    if [ -f "makeSymlinks.sh" ]; then
      cat makeSymlinks.sh >> new_makeSymlinks.sh
      rm -f makeSymlinks.sh
    fi
  fi
done

mv new_makeSymlinks.sh makeSymlinks.sh

$INIT_DIR/tools/create-dwarfs-pkg.sh "Windroid-RootFS" "Windroid RootFS $ROOTFS_VERSION" "" "$ARCH" "($GIT_SHORT_SHA)" "rootfs" "$PWD" "$INIT_DIR"

cd "$INIT_DIR"

rm -rf /tmp/$RAND_VAL
