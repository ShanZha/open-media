#include "om_impl.h"

#define STREAM_DURATION   10.0
#define STREAM_FRAME_RATE 30 /* fps: 30 images/s */
#define STREAM_PIX_FMT  AV_PIX_FMT_YUV420P/*default pix_fmt ==>PIX_FMT_YUV420P */

#ifdef __ANDROID__
JavaVM * gs_jvm;
jobject gj_omimpl;

jint JNI_OnLoad(JavaVM *vm, void * reserved)
{
	gs_jvm = vm;
	return JNI_VERSION_1_2;
}
#endif

/* Add an output stream. */
void init_output_stream(AVStream **st, AVFormatContext *oc, AVCodec **codec,
		enum AVCodecID codec_id, int width, int height) {
	AVCodecContext *c;
	const char * codecName;
	int i;
	codecName = avcodec_get_name(codec_id);
	/* find the encoder */
	*codec = avcodec_find_encoder(codec_id);
	//
	*st = avformat_new_stream(oc, *codec);
        //(*st)->id = oc->nb_streams - 1;
        (*st)->id = oc->nb_streams + 1;
	c = (*st)->codec;
	//configure parameters
	switch ((*codec)->type) {
	case AVMEDIA_TYPE_AUDIO:
		c->codec_id = codec_id;	//CODEC_ID_ADPCM_IMA_WAV;//steve-add
		c->codec_type = AVMEDIA_TYPE_AUDIO;	//steve-add
		c->sample_fmt = AV_SAMPLE_FMT_S16;	//steve-update
//		c->sample_fmt = (*codec)->sample_fmts ?
//						(*codec)->sample_fmts[0] : AV_SAMPLE_FMT_FLTP;
		c->bit_rate = 44100;	//44100;	//64000;
//		c->frame_size = 256;	//steve-add
//		c->block_align = 256;	//steve-add
        	c->sample_rate = 11025;	//11025;	//steve-update: 44100;
		if ((*codec)->supported_samplerates) {
			c->sample_rate = (*codec)->supported_samplerates[0];
			for (i = 0; (*codec)->supported_samplerates[i]; i++) {
//				if ((*codec)->supported_samplerates[i] == 44100)
//					c->sample_rate = 44100;
        			if ((*codec)->supported_samplerates[i] == 11025)
					c->sample_rate = 11025;
			}
		}
		c->channels = av_get_channel_layout_nb_channels(c->channel_layout);	//covered below
		c->channel_layout = AV_CH_LAYOUT_STEREO;
		if ((*codec)->channel_layouts) {
			c->channel_layout = (*codec)->channel_layouts[0];
			for (i = 0; (*codec)->channel_layouts[i]; i++) {
				if ((*codec)->channel_layouts[i] == AV_CH_LAYOUT_STEREO)
					c->channel_layout = AV_CH_LAYOUT_STEREO;
			}
		}
		c->channels = av_get_channel_layout_nb_channels(c->channel_layout);
//		c->channels = 1;	//steve-add
		(*st)->time_base = (AVRational ) { 1, c->sample_rate };
		break;
	case AVMEDIA_TYPE_VIDEO:
		c->bit_rate = 1000000; //400000;
		/* Resolution must be a multiple of two. */
		c->width = width; //352;
		c->height = height; //288;
		/* timebase: This is the fundamental unit of time (in seconds) in terms
		 * of which frame timestamps are represented. For fixed-fps content,
		 * timebase should be 1/framerate and timestamp increments should be
		 * identical to 1. */
		(*st)->time_base = (AVRational ) { 1, STREAM_FRAME_RATE };
		c->time_base = (*st)->time_base;

		c->gop_size = 12; /* emit one intra frame every twelve frames at most */
		c->pix_fmt = STREAM_PIX_FMT; //
		if (c->codec_id == AV_CODEC_ID_MPEG2VIDEO) {
			/* just for testing, we also add B frames */
			c->max_b_frames = 2;
		}
		if (c->codec_id == AV_CODEC_ID_MPEG1VIDEO) {
			/* Needed to avoid using macroblocks in which some coeffs overflow.
			 * This does not happen with normal video, it just happens here as
			 * the motion of the chroma plane does not match the luma plane. */
			c->mb_decision = 2;
		}
		av_opt_set(c->priv_data, "preset", "superfast", 0);
		av_opt_set(c->priv_data, "tune", "zerolatency", 0);
		break;

	default:
		break;
	}

	/* Some formats want stream headers to be separate. */
	if (oc->oformat->flags & AVFMT_GLOBALHEADER)
		c->flags |= CODEC_FLAG_GLOBAL_HEADER;
}

void init() {
   ntlog("init, %d, %s, %s\n", __LINE__, __FUNCTION__, __FILE__);
   ntlog("av_register_all");
   av_register_all();
   ntlog("avcodec_register_all");
   avcodec_register_all();
   ntlog("encode-h264-to-mp4");
   exec_encode_mp4(640, 240);
}

void dosomething(){
}

void callbacks() {
}

void interfaces() {
}

void release() {
}

#ifdef BUILD_EXEC
int main() {

   ntlog("stv==>exec:main, %d, %s, %s\n", __LINE__, __FUNCTION__, __FILE__);
   init();
   
   
   return 0;
}
#endif

int exec_encode_mp4(int video_width, int video_height) {
        AVFormatContext * fmt_ctx;
        AVOutputFormat *fmt;
        AVStream *video_output_stream, *audio_output_stream;
        AVCodec *audio_codec, *video_codec;
        AVPacket pkt;
        const char * filename = "/sdcard/steve-test-encoder.mp4";
        int have_video = 0, have_audio = 0;
        int i, ret;
        ret = avformat_alloc_output_context2(&fmt_ctx, NULL, NULL, filename);
        if (ret >= 0) {
                ntlog("avformat_alloc_output_context2 done [fmt_ctx]");
        } else {
                ntlog("avformat_alloc_output_context2 failed [fmt_ctx] @time=1, %d, %s, %s\n", __LINE__, __FUNCTION__, __FILE__);
        }
        if (fmt_ctx == NULL) {
                ntlog("Could not deduce output format from file extension: using MPEG. \n");
                avformat_alloc_output_context2(&fmt_ctx, NULL, "mpeg", NULL);
                if (fmt_ctx == NULL) {
                        ntlog("avformat_alloc_output_context2 failed [fmt_ctx] @time=2, %d, %s, %s\n", __LINE__, __FUNCTION__, __FILE__);
                        return 1;
                } else {
                        ntlog("avformat_alloc_output_context2 done [fmt_ctx] @time=2 for MPEG, %d, %s, %s\n", __LINE__, __FUNCTION__, __FILE__);
                }
        }

        fmt = fmt_ctx->oformat;
        /* Add the audio and video streams using the default format codecs
	 * and initialize the codecs. */
	if (fmt->video_codec != AV_CODEC_ID_NONE) {
	        ntlog("init output stream for video: %d, %d", video_width, video_height);
		init_output_stream(&video_output_stream, fmt_ctx, &video_codec,
				fmt->video_codec, video_width, video_height);
		have_video = 1;
	}
	if (fmt->audio_codec != AV_CODEC_ID_NONE) {
	        ntlog("init output stream for audio");
		init_output_stream(&audio_output_stream, fmt_ctx, &audio_codec,
				fmt->audio_codec, 0, 0);
		have_audio = 1;
	}
	/* Now that all the parameters are set, we can open the audio and
	 * video codecs and allocate the necessary encode buffers. */
	if (have_video) {
		ret = avcodec_open2(video_output_stream->codec, video_codec, NULL);
		ntlog("avcodec_open2(video-codec)=%d, %d, %s, %s\n", ret,
				__LINE__, __FUNCTION__, __FILE__);
		if (ret != 0) {
			ntlog("ffmpeg=>error: %s", av_err2str(ret));
		}
	}
	if (have_audio) {
		ret = avcodec_open2(audio_output_stream->codec, audio_codec, NULL);
		ntlog("avcodec_open2(audio-codec)=%d, %d, %s, %s\n", ret,
				__LINE__, __FUNCTION__, __FILE__);
		if (ret != 0) {
			ntlog("ffmpeg=>error: %s", av_err2str(ret));
		}
	}
	
	/* open the output file, if needed */
	if (!(fmt->flags & AVFMT_NOFILE)) {
                ntlog("avformat need avio_open: try avio_open(%s), %d, %s, %s",
				filename, __LINE__, __FUNCTION__, __FILE__);
		ret = avio_open(&fmt_ctx->pb, filename, AVIO_FLAG_READ_WRITE);
		if (ret < 0) {
			ntlog("avio_open() failed, could not open '%s': %s %d, %s, %s",
					filename, av_err2str(ret), __LINE__,
					__FUNCTION__, __FILE__);
			return -6;
		} else {
                        ntlog ("avio-open(%s) done, %d, %s, %s\n",
					filename, __LINE__, __FUNCTION__, __FILE__);
		}
	} else {
		ntlog("avformat has file, avio_open not needed, %d, %s, %s\n",
				__LINE__, __FUNCTION__, __FILE__);
	}
	
	/* Write the stream header, if any. */
	ret = avformat_write_header(fmt_ctx, NULL);
	if (ret != 0) {
		ntlog("avformat_write_header failed %s, %d, %s, %s\n",
				av_err2str(ret), __LINE__, __FUNCTION__, __FILE__);
		return 1;
	} else {
		ntlog("avformat_write_header done, %d, %s, %s\n", __LINE__,
				__FUNCTION__, __FILE__);
	}
	
	ntlog("av_init_packet");
//	av_init_packet(&pkt);
//
//	//setup video packet
        ntlog("if is video packet: reset pkt flags.");
//      pkt.stream_index = video_output_stream->index;
//      int start_timestamp = 0;
//	int curr_timestamp = 0;//datafifo_head(&datafifo)->arg.timestamp;
//      int timestamp = curr_timestamp - start_timestamp;
        ntlog("av_cascale_q: reset timestamp.");
//	pkt.pts = pkt.dts = av_rescale_q(timestamp, (AVRational){1, 1000}, video_output_stream->time_base);
//
        ntlog("if is audio packet: reset pkt flags.");
//      //setup audio packet
//      pkt.stream_index = audio_output_stream->index;//
//	
        ntlog("for every key frame, pkt.flags |= AV_PKT_FLAG_KEY ");
//	//for both audio/video frames
//      if (frame_flag & FRAME_FLAG_KEYFRAME) {//is key frame
//              pkt.flags |= AV_PKT_FLAG_KEY;
//      }
//
        ntlog("fill in pkt.data and set pkt.size");
//      pkt.data = ;
//      pkt.size = ;
        ntlog("av_write_frame(fmt_ctx, &pkt)...");
//      ret = av_write_frame(fmt_ctx, &pkt);
	
        ret = av_write_trailer(fmt_ctx);
        ntlog("av_write_trailer=%d, %d, %s, %s\n", ret, __LINE__,
			__FUNCTION__, __FILE__);
	for (i = 0; i < fmt_ctx->nb_streams; i++) {
		av_freep(&fmt_ctx->streams[i]->codec);
		av_freep(&fmt_ctx->streams[i]);
	}

	if (!(fmt_ctx->oformat->flags & AVFMT_NOFILE)) {
		ntlog("avio_close, %d, %s, %s\n", __LINE__, __FUNCTION__,
				__FILE__);
		avio_close(fmt_ctx->pb);
	}

	ntlog("av_free: fmt_ctx");
	av_free(fmt_ctx);
	return 0;
}

void exec_decode_h264(int video_width, int video_height) {
        struct SwsContext *img_convert_ctx;
        AVCodecContext *c;
        AVCodec *codec;
        AVFrame *picture;
        AVPacket pkt;
	/* must be called before using avcodec lib */
	/* register all the codecs */
	av_register_all();
	avcodec_register_all();

        codec =	avcodec_find_decoder(CODEC_ID_H264);
        if(!c) {
                return;
        }
        c = avcodec_alloc_context3(codec);
        picture = av_frame_alloc();
	av_init_packet(&pkt);
	
	if(codec->capabilities & CODEC_CAP_TRUNCATED)
                c->flags |= CODEC_FLAG_TRUNCATED; /* we do not send complete frames */
        c->width=video_width;
        c->height=video_height;
	
	if (avcodec_open2(c, codec, NULL) < 0) {
		ntlog("could not open codec\n");
		return;
	}
	
	//NOTE: c->pix_fmt is -1 here
#ifdef __ANDROID__
	img_convert_ctx = sws_getContext(video_width, video_height, PIX_FMT_YUV420P /*c->pix_fmt */, video_width, video_height, PIX_FMT_RGB565LE /* PIX_FMT_RGBA */, SWS_FAST_BILINEAR, NULL, NULL, NULL);
#endif
#ifdef __IOS__
	img_convert_ctx = sws_getContext(video_width, video_height, PIX_FMT_YUV420P /* c->pix_fmt */, video_width, video_height, PIX_FMT_RGBA, SWS_FAST_BILINEAR, NULL, NULL, NULL);
#endif
        //decode every frame below...
}

#ifdef __ANDROID__
void Java_com_xxx_xxxx_nativeInit(JNIEnv*  env, jobject obj, jint cpu_type, jint has_fpu, jint has_neon)
#endif
#ifdef __IOS__
void nativeInit(int cpu_type, int has_fpu, int neon)
#endif
{

#ifdef __ANDROID__
        gj_omimpl = (*env)->NewGlobalRef(env, obj);
#endif
#ifdef __IOS__
        //
#endif

}
