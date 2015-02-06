#!/bin/bash

# Set NDK to the full path to your NDK install
#NDK="/home/dzhao2x/android-ndk-r8e"
NDK="/home/sn/dev_env/android-ndk-r9d"
#DIR="/home/dzhao2x/android-ffmpeg-x264-faac-latest/"
DIR="/media/sn/Lenovo_150G/workspace/goscam_svn/ip3g_prjs/pj016_p2p_lib/trunk/open-media"
export PATH=$PATH:$NDK:$DIR/toolchain/bin

ANDROID_CFLAGS="-DANDROID -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__ -ffunction-sections -funwind-tables -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -Wa,--noexecstack -Os "
ANDROID_CXXFLAGS="-DANDROID -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__ -ffunction-sections -funwind-tables -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -fno-exceptions -fno-rtti -mthumb -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -Wa,--noexecstack -Os "

PREFIX=arm-linux-androideabi-
export AR=${PREFIX}ar
export AS=${PREFIX}gcc
export CC=${PREFIX}gcc
export CXX=${PREFIX}g++
export LD=${PREFIX}ld
export NM=${PREFIX}nm
export RANLIB=${PREFIX}ranlib
export STRIP=${PREFIX}strip
export CFLAGS=${ANDROID_CFLAGS}
export CXXFLAGS=${ANDROID_CXXFLAGS}
export CPPFLAGS=${ANDROID_CPPFLAGS}

config_clean()
{
	make distclean &>/dev/null
	rm config.cache &>/dev/null
	rm config.log &>/dev/null
}

config_faac()
{
	echo -e "Configuring FAAC"
	config_clean
	./configure --host=arm-linux \
                --prefix=/media/sn/Lenovo_150G/workspace/goscam_svn/ip3g_prjs/pj016_p2p_lib/trunk/open-media/output/faac/armeabi-v7a \
                --disable-dependency-tracking \
                --enable-shared \
                --enable-static \
                --with-pic \
                --without-mp4v2
}

compile_faac()
{
	echo -e "Compiling FAAC"
    make clean
    make install
#    cp -v libfaac/.libs/libfaac.a ../ffmpeg
}

config_faac
compile_faac
