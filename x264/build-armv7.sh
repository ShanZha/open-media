#!/bin/bash
NDK="/home/sn/dev_env/android-ndk-r9d"
SRC_DIR="/media/sn/Lenovo_150G/workspace/goscam_svn/ip3g_prjs/pj016_p2p_lib/trunk/open-media"
OUTPUT=$SRC_DIR/output

ANDROID_CFLAGS="-DANDROID -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__ -ffunction-sections -funwind-tables -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -Wa,--noexecstack -Os "

ANDROID_CXXFLAGS="-DANDROID -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__ -ffunction-sections -funwind-tables -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -fno-exceptions -fno-rtti -mthumb -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -Wa,--noexecstack -Os "

#1.使用交叉编译链工具的方法编译
#PREBUILT=../toolchain
#export PATH=$PATH:$NDK:$SRC_DIR/toolchain/bin
CROSS_COMPILE=arm-linux-androideabi-
export AR=${CROSS_COMPILE}ar
export AS=${CROSS_COMPILE}gcc
export CC=${CROSS_COMPILE}gcc
export CXX=${CROSS_COMPILE}g++
export LD=${CROSS_COMPILE}ld
export NM=${CROSS_COMPILE}nm
export RANLIB=${CROSS_COMPILE}ranlib
export STRIP=${CROSS_COMPILE}strip
export CFLAGS=${ANDROID_CFLAGS}
export CXXFLAGS=${ANDROID_CXXFLAGS}
export CPPFLAGS=${ANDROID_CPPFLAGS}
SDFLAGS="-nostdlib -Wl,-T,armelf.xsc -Wl,-shared,-Bsymbolic -Wl,-soname,$@ -lc"
export SDFLAGS=${SDFLAGS}

#2.使用NDK直接编译
PREFIX=$OUTPUT/x264/android/armeabi-v7a
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86
PLATFORM=$NDK/platforms/android-14/arch-arm

# --disable-cli \
./configure --prefix=$PREFIX \
            --enable-shared \
            --enable-static \
            --enable-pic \
            --disable-asm \
            --host=arm-linux \
            --cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
            --sysroot=$PLATFORM

make clean
make -j4
make install
