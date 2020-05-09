#!/bin/bash
BUILD_START=$(date +"%s")

# Colours
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

# Kernel details
KERNEL_NAME="GunMetal™"
VERSION="R6"
DATE=$(date +"%d-%m-%Y-%I-%M")
DEVICE="Z00xD"
FINAL_ZIP=$KERNEL_NAME-$VERSION-$DATE-$DEVICE.zip
BRANCH="9.x-staging"
defconfig=ze500kl-custom_defconfig

# Dirs
KERNEL_DIR=$(pwd)
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel3
KERNEL_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
UPLOAD_DIR=$(pwd)/out-zip/

# Export
export ARCH=arm64
export CROSS_COMPILE=$(pwd)/aarch64-elf-gcc/bin/aarch64-elf-

# Toolchain Used: https://github.com/kdrag0n/aarch64-elf-gcc
## Functions ##
# Clone
# Toolchain
git clone https://github.com/kdrag0n/aarch64-elf-gcc
ranlib $(pwd)/aarch64-elf-gcc/lib/gcc/aarch64-elf/9.1.0/libgcc.a

# Make kernel
  echo -e "$cyan***********************************************"
  echo -e "          Initializing defconfig          "
  echo -e "***********************************************$nocol"
rm -rf out
mkdir out
make O=out $defconfig
  echo -e "$cyan***********************************************"
  echo -e "             Building kernel          "
  echo -e "***********************************************$nocol"

make O=out -j$(nproc --all) || echo "Build Failed!
Go and fix errors!" && exit

# Making zip
function make_zip() {
cp $KERNEL_IMG $ANYKERNEL_DIR
mkdir -p $UPLOAD_DIR
cd $ANYKERNEL_DIR
zip -r9 UPDATE-AnyKernel3.zip *
mv $ANYKERNEL_DIR/UPDATE-AnyKernel3.zip $UPLOAD_DIR/$FINAL_ZIP
Version: $VERSION
Date: $DATE
Branch: $BRANCH
}

     echo -e "$cyan***********************************************"
     echo -e "     Making flashable zip        "
     echo -e "***********************************************$nocol"
     make_zip

# Clean Up
function cleanup(){
rm -rf $ANYKERNEL_DIR/Image.gz-dtb
}

cleanup
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
  

