#!/bin/bash
#OS_DIRS
OS_INC=/usr/local/include
OS_LIB=/usr/local/lib
#本地路径
SRC_DIR=$(pwd)
OUTPUT=$SRC_DIR/../output
#PREFIX:最终编译的ffmpeg库及头文件的输出路径
PREFIX=$OUTPUT/ffmpeg/android/armeabi-v7a
#NDK路径
NDK=/home/sn/dev_env/android-ndk-r10d
#NDK平台
PLATFORM=$NDK/platforms/android-14/arch-arm
PLATFORM_INC=$PLATFORM/usr/include
PLATFORM_LIB=$PLATFORM/usr/lib
#交叉编译链-编译链前缀
PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86
CC=$PREBUILT/bin/arm-linux-androideabi-gcc
NM=$PREBUILT/bin/arm-linux-androideabi-nm
LD=$PREBUILT/bin/arm-linux-androideabi-ld
CROSS_PREFIX=$PREBUILT/bin/arm-linux-androideabi-
#CPU架构
ARCH=arm
#CPU型号及相关优化选项
CPU=armv7-a
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU "
ADDITIONAL_CONFIGURE_FLAG=
#faac
FAAC_OUTPUT=$OUTPUT/faac/android/armeabi-v7a
FAAC_INC=$FAAC_OUTPUT/include
FAAC_LIB=$FAAC_OUTPUT/lib
#x264
X264_OUTPUT=$OUTPUT/x264/android/armeabi-v7a
X264_INC=$X264_OUTPUT/include
X264_LIB=$X264_OUTPUT/lib

CFLAGS="-I$FAAC_INC -I$X264_INC -O3 -fpic -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS -I$OS_INC "
LDFLAGS="-Wl,-rpath-link=$PLATFORM_LIB -L$PLATFORM_LIB -nostdlib -lc -lm -ldl -llog -L$FAAC_LIB -lfaac -L$X264_LIB -lx264 -L$OS_LIB "

function build_one
{
./configure  --target-os=linux \
 --prefix=$PREFIX \
 --enable-cross-compile \
 --enable-runtime-cpudetect \
 --arch=$ARCH \
 --cc=$CC \
 --cross-prefix=$CROSS_PREFIX \
 --disable-stripping \
 --nm=$NM \
 --sysroot=$PLATFORM \
 --enable-shared \
 --enable-static \
 --extra-libs="-lgcc" \
 --extra-cflags="$CFLAGS " \
 --extra-ldflags="$LDFLAGS " \
 --disable-asm \
 --disable-decoders \
 --disable-encoders \
 --disable-demuxers \
 --disable-muxers \
 --disable-parsers \
 --disable-protocols \
 --disable-avdevice \
 --disable-filters \
 --disable-devices \
 --disable-ffprobe \
 --disable-ffmpeg \
 --disable-ffplay \
 --disable-ffserver \
 --disable-hwaccels \
 --disable-network \
 --enable-gpl \
 --enable-version3 \
 --enable-nonfree \
 --enable-libfaac \
 --enable-libx264 \
 --enable-zlib \
 --enable-decoder=rawvideo \
 --enable-decoder=acc \
 --enable-decoder=h264 \
 --enable-encoder=libfaac \
 --enable-encoder=aac \
 --enable-encoder=libx264 \
 --enable-encoder=h264 \
 --enable-muxer=mp4 \
 --enable-parser=h264 \
 --enable-protocol=file \
 --enable-avformat \
 --enable-avresample \
 $ADDITIONAL_CONFIGURE_FLAG

#make clean
#make -j4 install
#$PREBUILT/bin/arm-linux-androideabi-ar d libavcodec/libavcodec.a inverse.o
#$PREBUILT/bin/arm-linux-androideabi-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -soname libffmpeg.so -shared -nostdlib -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a -lc -lm -lz -ldl -llog --warn-once --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/arm-linux-androideabi/4.4.3/libgcc.a
}
build_one
make clean
make -j4
make install

