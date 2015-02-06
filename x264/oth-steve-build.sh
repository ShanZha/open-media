#!/bin/sh
#配置关键点1：指定使用的交叉编译的编译器、链接的头文件及类库所在
#配置关键点2：-march=armv7-a -mtune=cortex-a9 -mfloat-abi=softfp -mfpu=neon -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__ ，
#	此处，针对armv7-a的CPU打开了NEON的优化运行指令。
#配置关键点3：去掉--disable-asm选项。该选项的意思就是禁止neon的指令。
#配置关键点4：添加--enable-static选项，生成静态链接的库供程序开发使用

ANDROID_NDK_ROOT=$ANDROID_NDK
PREBUILT=$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86
PLATFORM=$ANDROID_NDK_ROOT/platforms/android-14/arch-arm
ARM_INC=$PLATFORM/usr/include
ARM_LIB=$PLATFORM/usr/lib
ARM_LIBO=$PREBUILT/lib/gcc/arm-linux-androideabi/4.8

./configure --disable-gpac --enable-pic --enable-strip \
	--extra-cflags=" -I$ARM_INC -fPIC -DANDROID -fpic -mthumb-interwork -ffunction-sections -funwind-tables -fstack-protector -fno-short-enums -march=armv7-a -mtune=cortex-a9 -mfloat-abi=softfp -mfpu=neon -D__ARM_ARCH_7__ -D__ARM_ARCH_7A__ -Wno-psabi -msoft-float -mthumb -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID -Wa,--noexecstack -MMD -MP " \
	--extra-ldflags="-nostdlib -Bdynamic -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,nocopyreloc -Wl,-soname,/system/lib/libz.so -Wl,-rpath-link=$ARM_LIB,-dynamic-linker=/system/bin/linker -L$ARM_LIB -nostdlib $ARM_LIB/crtbegin_dynamic.o $ARM_LIB/crtend_android.o -lc -lm -ldl -lgcc" \
	--cross-prefix=$PREBUILT/bin/arm-linux-androideabi- \
	--host=arm-linux \
	--enable-static \
	--prefix='dist'