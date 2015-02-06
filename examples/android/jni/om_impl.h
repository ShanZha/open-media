#ifndef _OM_IMPL_H_
#define _OM_IMPL_H_

//it's defined by compiler
//#define __ANDROID__
//it's defined by ndk
//#define ANDROID_LOG_DEBUG 0

#include <sys/time.h>
#include <time.h>

#include <stdint.h>

#include <pthread.h>

#include "libavutil/imgutils.h"
#include "libavutil/opt.h"
#include "libavformat/avformat.h"
#include "libavformat/avio.h"
#include "libswscale/swscale.h"
#include "libavcodec/avcodec.h"
#include "libavutil/mathematics.h"
#include "libavutil/samplefmt.h"

#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>

#include <jni.h>
#include <android/log.h>

#define ntlog(x...) __android_log_print(ANDROID_LOG_DEBUG, "stv_openmedia", x)

typedef unsigned char       u8;
typedef signed   char       s8;
typedef unsigned short      u16;
typedef signed   short      s16;
typedef unsigned int        u32;
typedef signed   int        s32;
typedef unsigned long long  u64;
typedef signed   long long  s64;

/******* global variables *********/
extern JavaVM * gs_jvm; //JVM can be used for all the threads

extern jobject gj_omimpl; //cache for Java openmedia object, it's GlobalRef, so can be used in other threads.

#ifdef OM_DEBUG
#define MY_OM_IMPL
#endif

void init_output_stream(AVStream **st, AVFormatContext *oc, AVCodec **codec,
		enum AVCodecID codec_id, int width, int height);
int exec_encode_mp4(int video_width, int video_height);

#endif
