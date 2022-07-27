import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class VideoImageViewPage extends StatefulWidget {
  int type = 0;
  String url = "";
  VideoImageViewPage({Key? key, required this.url, required this.type})
      : super(key: key);

  @override
  State<VideoImageViewPage> createState() => _VideoImageViewPageState();
}

class _VideoImageViewPageState extends State<VideoImageViewPage> {
  VideoPlayerController? _controller;
  bool isPlaying = false;
  double positionTime = 0;
  double totalTime = 0;
  @override
  void initState() {
    super.initState();
    if (widget.type == 0) {
      _controller =
          VideoPlayerController.network(IMAGE_URL + widget.url.toString())
            ..initialize().then((_) {
              setState(() {});
            });

      _controller!.addListener(() {
        if (_controller!.value.position == _controller!.value.duration) {
          setState(() {
            isPlaying = false;
          });
          _controller!.initialize();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          backgroundColor: black,
        ),
        body: Center(child: widget.type == 1 ? imageView() : videoView()));
  }

  Widget videoView() {
    return Container(
      height: 200,
      color: black,
      width: phoneWidth(context),
      child: _controller!.value.isInitialized
          ? Stack(
              children: [
                Container(
                  child: VideoPlayer(_controller!),
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                      _controller!.value.isPlaying
                          ? _controller!.pause()
                          : _controller!.play();
                    },
                    child: CircleAvatar(
                      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      radius: 33,
                      backgroundColor: Colors.black38,
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget imageView() {
    return Container(
      height: phoneHeight(context) - 100,
      width: phoneWidth(context) - 45,
      child: CachedNetworkImage(
        imageUrl: widget.url,
        imageBuilder: (context, url) {
          return Image.network(widget.url, fit: BoxFit.cover, loadingBuilder:
              (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          });
        },
      ),
    );
  }
}
