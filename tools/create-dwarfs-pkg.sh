#!/bin/bash
showHelp()
{
	echo "Usage: $0 [package name] [package pretty name] [vulkan driver lib name] [architecture] [version] [category] [destdir-pkg] [output folder]"
	echo ""
}

symlinkToSh() {
  for folder in $(find $1 -type d); do
    if [ -d "$folder" ]; then
      cd "$folder"

      for file in $(find $PWD -type l); do
        target=$(readlink $file)

        if [ "$target" != "nul" ]; then
          rm "$file"

          target=$(echo $target | sed "s@$WORKDIR@$APP_ROOT_DIR@g")
          file=$(echo $file | sed "s@$WORKDIR@$APP_ROOT_DIR@g")

          echo "ln -sf $target $file" >> $WORKDIR/makeSymlinks.sh
        fi
      done

      cd $OLDPWD
    fi
  done
}

if [ $# -lt 8 ]; then
	showHelp
	exit 0
fi

export INIT_DIR=$PWD
export APP_ROOT_DIR=/data/data/com.windroid.emu/

export PACKAGE_NAME=$1
export PACKAGE_PRETTY_NAME=$2
export PACKAGE_VK_DRIVER_LIB=$3
export PACKAGE_ARCHITECTURE=$4
export PACKAGE_VERSION=$5
export PACKAGE_CATEGORY=$6
export DESTDIR_PKG=$7
export OUTDIR=$8

if [ "$9" != "0" ]; then
  echo ""
  echo "Creating Package '$PACKAGE_NAME-$PACKAGE_VERSION-$PACKAGE_ARCHITECTURE.dwarfs'..."
fi

export WORKDIR="$DESTDIR_PKG"

if [ -d "$DESTDIR_PKG/data/" ]; then
	WORKDIR="$DESTDIR_PKG/data/data/com.windroid.emu/"
fi

cd $WORKDIR

echo "name=$PACKAGE_PRETTY_NAME" > pkg-header
echo "category=$PACKAGE_CATEGORY" >> pkg-header
echo "version=$PACKAGE_VERSION" >> pkg-header
echo "architecture=$PACKAGE_ARCHITECTURE" >> pkg-header
echo "vkDriverLib=$PACKAGE_VK_DRIVER_LIB" >> pkg-header

symlinkToSh "files/"

if command -v mkdwarfs &> /dev/null; then
  mkdwarfs -i . -o "$OUTDIR/$PACKAGE_NAME-$PACKAGE_VERSION-$PACKAGE_ARCHITECTURE.dwarfs" -f
else
  echo "Error: mkdwarfs is not installed. Unable to create DwarFS package."
  exit 1
fi
