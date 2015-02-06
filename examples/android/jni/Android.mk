LOCAL_PATH := $(call my-dir)
##############################################################################
OPEN_MEDIA=$(LOCAL_PATH)/openmedia
FAAC_INC := $(OPEN_MEDIA)/faac/$(TARGET_ARCH_ABI)/include
FAAC_LIB := $(OPEN_MEDIA)/faac/$(TARGET_ARCH_ABI)/lib
FFMPEG_LIB := $(OPEN_MEDIA)/ffmpeg/$(TARGET_ARCH_ABI)/lib
FFMPEG_INC := $(OPEN_MEDIA)/ffmpeg/$(TARGET_ARCH_ABI)/include
X264_INC := $(OPEN_MEDIA)/x264/$(TARGET_ARCH_ABI)/include
X264_LIB := $(OPEN_MEDIA)/x264/$(TARGET_ARCH_ABI)/lib
##############################################################################
ANDROID_LOG_DEBUG := 1
neon := 0
YOUR_CONDITION := 1
##############################################################################
include $(CLEAR_VARS)
#module-name
LOCAL_MODULE := openmedia
#cflags: where are your including head files
LOCAL_CFLAGS := -DANDROID_NDK
LOCAL_CFLAGS += -I$(FAAC_INC)
LOCAL_CFLAGS += -I$(X264_INC)
LOCAL_CFLAGS += -I$(FFMPEG_INC)
#just for debug
LOCAL_CFLAGS += -UNDEBUG -D_DEBUG

#source-files: what have your done(your-implements)
LOCAL_SRC_FILES := om_impl.c

#if we need to do something..

ifeq ($(YOUR_CONDITION), 1)
ifeq ($(neon), 1)
LOCAL_SRC_FILES += 
else
LOCAL_SRC_FILES += 
endif
else
ifeq ($(neon), 1)
LOCAL_SRC_FILES += 
else
LOCAL_SRC_FILES += 
endif
endif

FAAC_LDLIBS := $(addprefix $(FAAC_LIB)/, \
libfaac.a )
X264_LDLIBS := $(addprefix $(X264_LIB)/, \
libx264.a )
#顺序不可更改
FFMPEG_LDLIBS := $(addprefix $(FFMPEG_LIB)/, \
libavformat.a \
libavcodec.a \
libavresample.a \
libpostproc.a \
libavfilter.a \
libswresample.a \
libavutil.a \
libswscale.a )
#顺序不可更改
LOCAL_LDLIBS := -llog -lGLESv2 -lz
LOCAL_LDLIBS += -l$(FFMPEG_LDLIBS)
LOCAL_LDLIBS += -l$(FAAC_LDLIBS)
LOCAL_LDLIBS += -l$(X264_LDLIBS)

#LOCAL_STATIC_LIBRARIES := avformat avcodec avresample postproc avfilter swresample avutil swscale faac x264

include $(BUILD_SHARED_LIBRARY)
##############################################################################


include $(CLEAR_VARS)
#module-name
LOCAL_MODULE := openmedia-exec
#cflags: where are your including head files
LOCAL_CFLAGS := -DANDROID_NDK
LOCAL_CFLAGS += -I$(FAAC_INC)
LOCAL_CFLAGS += -I$(X264_INC)
LOCAL_CFLAGS += -I$(FFMPEG_INC)
#just for debug
LOCAL_CFLAGS += -UNDEBUG -D_DEBUG
LOCAL_CFLAGS += -DBUILD_EXEC

#source-files: what have your done(your-implements)
LOCAL_SRC_FILES := om_impl.c

#if we need to do something..
ifeq ($(YOUR_CONDITION), 1)
ifeq ($(neon), 1)
LOCAL_SRC_FILES += 
else
LOCAL_SRC_FILES += 
endif
else
ifeq ($(neon), 1)
LOCAL_SRC_FILES += 
else
LOCAL_SRC_FILES += 
endif
endif

FAAC_LDLIBS := $(addprefix $(FAAC_LIB)/, \
libfaac.a )
X264_LDLIBS := $(addprefix $(X264_LIB)/, \
libx264.a )
#顺序不可更改
FFMPEG_LDLIBS := $(addprefix $(FFMPEG_LIB)/, \
libavformat.a \
libavcodec.a \
libavresample.a \
libpostproc.a \
libavfilter.a \
libswresample.a \
libavutil.a \
libswscale.a )
#顺序不可更改
LOCAL_LDLIBS := -llog -lGLESv2 -lz
LOCAL_LDLIBS += -l$(FFMPEG_LDLIBS)
LOCAL_LDLIBS += -l$(FAAC_LDLIBS)
LOCAL_LDLIBS += -l$(X264_LDLIBS)

#LOCAL_STATIC_LIBRARIES := avformat avcodec avresample postproc avfilter swresample avutil swscale faac x264

include $(BUILD_EXECUTABLE)
