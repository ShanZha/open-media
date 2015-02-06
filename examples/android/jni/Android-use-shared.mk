LOCAL_PATH := $(call my-dir)
##############################################################################
#前提: 编译出来的所有依赖库都不包含版本信息, 
#      编译前设定soname或在编译后使用arm-ld以及arm-ranld等工具处理
OPEN_MEDIA:=$(LOCAL_PATH)/openmedia
##############################################################################
#faac
FAAC_INC := $(OPEN_MEDIA)/faac/$(TARGET_ARCH_ABI)/include
FAAC_LIB := $(OPEN_MEDIA)/faac/$(TARGET_ARCH_ABI)/lib

include $(CLEAR_VARS)
LOCAL_MODULE := faac
# $(FAAC_LIB)/libfaac.la
LOCAL_SRC_FILES := $(FAAC_LIB)/libfaac.so
LOCAL_EXPORT_C_INCLUDES := $(FAAC_INC)
include $(PREBUILT_SHARED_LIBRARY)  

##############################################################################
#x264
X264_INC := $(OPEN_MEDIA)/x264/$(TARGET_ARCH_ABI)/include
X264_LIB := $(OPEN_MEDIA)/x264/$(TARGET_ARCH_ABI)/lib

include $(CLEAR_VARS)

LOCAL_MODULE := x264
LOCAL_SRC_FILES := $(X264_LIB)/libx264.so
LOCAL_EXPORT_C_INCLUDES := $(X264_INC)
include $(PREBUILT_SHARED_LIBRARY) 

##############################################################################
#ffmpeg
FFMPEG_LIB := $(OPEN_MEDIA)/ffmpeg/$(TARGET_ARCH_ABI)/lib
FFMPEG_INC := $(OPEN_MEDIA)/ffmpeg/$(TARGET_ARCH_ABI)/include

#ffmpeg-avcodec
include $(CLEAR_VARS)
LOCAL_MODULE := avcodec
LOCAL_SRC_FILES := $(FFMPEG_LIB)/libavcodec.so
#LOCAL_EXPORT_C_INCLUDES := $(FFMPEG_INC)/libavcodec
include $(PREBUILT_SHARED_LIBRARY)   
#ffmpeg-avformat
include $(CLEAR_VARS)
LOCAL_MODULE := avformat
LOCAL_SRC_FILES := $(FFMPEG_LIB)/libavformat.so
#LOCAL_EXPORT_C_INCLUDES := $(FFMPEG_INC)/libavformat
include $(PREBUILT_SHARED_LIBRARY)
#ffmpeg-avfilter
include $(CLEAR_VARS)
LOCAL_MODULE := avfilter
LOCAL_SRC_FILES := $(FFMPEG_LIB)/libavfilter.so
#LOCAL_EXPORT_C_INCLUDES := $(FFMPEG_INC)/libavfilter
include $(PREBUILT_SHARED_LIBRARY)
#ffmpeg-avresample
include $(CLEAR_VARS)
LOCAL_MODULE := avresample
LOCAL_SRC_FILES := $(FFMPEG_LIB)/libavresample.so
#LOCAL_EXPORT_C_INCLUDES := $(FFMPEG_INC)/libavresample
include $(PREBUILT_SHARED_LIBRARY) 
#ffmpeg-avutil
include $(CLEAR_VARS)
LOCAL_MODULE := avutil
LOCAL_SRC_FILES := $(FFMPEG_LIB)/libavutil.so
#LOCAL_EXPORT_C_INCLUDES := $(FFMPEG_INC)/libavutil
include $(PREBUILT_SHARED_LIBRARY)   
#ffmpeg-postproc
include $(CLEAR_VARS)
LOCAL_MODULE := postproc
LOCAL_SRC_FILES := $(FFMPEG_LIB)/libpostproc.so
#LOCAL_EXPORT_C_INCLUDES := $(FFMPEG_INC)/libpostproc
include $(PREBUILT_SHARED_LIBRARY) 
#ffmpeg-swresample
include $(CLEAR_VARS)
LOCAL_MODULE := swresample
LOCAL_SRC_FILES := $(FFMPEG_LIB)/libswresample.so
#LOCAL_EXPORT_C_INCLUDES := $(FFMPEG_INC)/libswresample
include $(PREBUILT_SHARED_LIBRARY)   
#ffmpeg-swscale
include $(CLEAR_VARS)
LOCAL_MODULE := swscale
LOCAL_SRC_FILES := $(FFMPEG_LIB)/libswscale.so
#LOCAL_EXPORT_C_INCLUDES := $(FFMPEG_INC)/libswscale
include $(PREBUILT_SHARED_LIBRARY)

##############################################################################
FAAC_INC := $(OPEN_MEDIA)/faac/$(TARGET_ARCH_ABI)/include
FAAC_LIB := $(OPEN_MEDIA)/faac/$(TARGET_ARCH_ABI)/lib
FFMPEG_LIB := $(OPEN_MEDIA)/ffmpeg/$(TARGET_ARCH_ABI)/lib
FFMPEG_INC := $(OPEN_MEDIA)/ffmpeg/$(TARGET_ARCH_ABI)/include
X264_INC := $(OPEN_MEDIA)/x264/$(TARGET_ARCH_ABI)/include
X264_LIB := $(OPEN_MEDIA)/x264/$(TARGET_ARCH_ABI)/lib
#other flags
neon := 0
DATAFIFO_DEBUG := 1

include $(CLEAR_VARS)

LOCAL_MODULE := openmedia

#$(FAAC_INC)  $(X264_INC) $(FFMPEG_INC)
LOCAL_CFLAGS := -DANDROID_NDK
LOCAL_CFLAGS += -I$(FAAC_INC)
LOCAL_CFLAGS += -I$(X264_INC)
LOCAL_CFLAGS += -I$(FFMPEG_INC)
#just for debug
LOCAL_CFLAGS += -UNDEBUG -D_DEBUG

#LOCAL_STATIC_LIBRARIES := faac x264 avformat avcodec avutil swscale postproc swresample

LOCAL_LDLIBS := -llog -lGLESv2 -lz 
LOCAL_LDLIBS += -L$(FAAC_LIB) -lfaac
LOCAL_LDLIBS += -L$(X264_LIB) -lx264
LOCAL_LDLIBS += -L$(FFMPEG_LIB) -lavcodec
LOCAL_LDLIBS += -L$(FFMPEG_LIB) -lavformat
LOCAL_LDLIBS += -L$(FFMPEG_LIB) -lavfilter
LOCAL_LDLIBS += -L$(FFMPEG_LIB) -lavresample
LOCAL_LDLIBS += -L$(FFMPEG_LIB) -lavutil
LOCAL_LDLIBS += -L$(FFMPEG_LIB) -lpostproc
LOCAL_LDLIBS += -L$(FFMPEG_LIB) -lswresample
LOCAL_LDLIBS += -L$(FFMPEG_LIB) -lswscale

include $(BUILD_SHARED_LIBRARY)
##############################################################################

