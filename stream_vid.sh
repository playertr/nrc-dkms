#!/bin/bash

gst-launch-1.0 v4l2src device=/dev/video0 io-mode=2 ! \
	video/x-raw, width=640, height=480, framerate=30/1 ! \
	nvvidconv ! \
	nvv4l2h264enc insert-sps-pps=1 insert-vui=1 idrinterval=30 \
		EnableTwopassCBR=0 maxperf-enable=1 preset-level=0 \
		peak-bitrate=500000 bitrate=500000 control-rate=0 ! \
	h264parse ! \
	rtph264pay config-interval=1 pt=96 ! \
	udpsink host=100.83.122.49 port=5000 sync=false async=false

