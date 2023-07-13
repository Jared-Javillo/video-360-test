import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:video_360/video_360.dart';
import 'package:video_360_test/codepan/dimensions.dart';
import 'package:video_360_test/codepan/icon.dart';
import 'package:video_360_test/codepan/if_else_builder.dart';

class Video360Page extends StatefulWidget {
  final String? initialLink;

  const Video360Page({
    super.key,
    this.initialLink,
  });

  @override
  Video360PageState createState() => Video360PageState();
}

class Video360PageState extends State<Video360Page> {
  late int? _duration;
  late int? _total;
  late final StreamSubscription _sub;

  Video360Controller? _controller;
  String? _videoLink;
  bool _isPaused = false;
  bool _isControlsVisible = false;
  bool _isTouchMovable = false;

  @override
  void initState() {
    super.initState();
    if (!(widget.initialLink == null)) {
      _videoLink = _extractVideoUrl(widget.initialLink!)!;
    }
    _duration = 0;
    _total = 1;
    _initUniLinks();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.playInfoStream
        ?.cancel()
        .then((value) => _controller?.dispose());
    _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final d = Dimension.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          if (_isControlsVisible) {
            _isControlsVisible = false;
          } else {
            _isControlsVisible = true;
          }
        });
      },
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: SizedBox(
                width: d.maxWidth,
                height: d.maxHeight,
                child: IgnorePointer(
                  ignoring: _isTouchMovable,
                  child: Video360View(
                    onVideo360ViewCreated: _onVideo360ViewCreated,
                    url:
                        "https://${_videoLink ?? 'github.com/stephangopaul/video_samples/blob/master/gb.mp4?raw=true'}",
                    onPlayInfo: (Video360PlayInfo info) {
                      if (mounted) {
                        if (info.duration != 0 && info.total != 0) {
                          setState(() {
                            if (info.duration <= info.total) {
                              _duration = info.duration;
                              _total = info.total;
                            }
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: _isControlsVisible,
              child: Stack(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_isPaused) {
                            _isPaused = false;
                            _controller?.play();
                          } else {
                            _isPaused = true;
                            _controller?.stop();
                          }
                        });
                      },
                      child: IfElseBuilder(
                        padding: EdgeInsets.symmetric(
                            horizontal: d.at(20), vertical: d.at(20)),
                        condition: _isPaused,
                        ifChild: PanIcon(
                          icon: 'play',
                          width: d.at(35),
                          height: d.at(35),
                          color: Colors.orange,
                          background: Colors.transparent,
                        ),
                        elseChild: PanIcon(
                          icon: 'pause',
                          width: d.at(35),
                          height: d.at(35),
                          color: Colors.orange,
                          background: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: d.at(60), horizontal: d.at(20)),
                        child: DurationBar(
                          controller: _controller,
                          total: _total,
                          duration: _duration,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            if (_isTouchMovable) {
              setState(() {
                _isTouchMovable = false;
                _isControlsVisible = false;
              });
            } else {
              setState(() {
                _isTouchMovable = true;
                _isControlsVisible = false;
              });
            }
          },
          child: PanIcon(
            icon: 'touch',
            width: d.at(30),
            height: d.at(30),
            color: Colors.orange,
          ),
        ),
      ),
    );
  }

  _onVideo360ViewCreated(Video360Controller? controller) {
    _controller = controller;
  }

  //TODO Removed when using real URI
  String? _extractVideoUrl(String urlString) {
    final urlStart = urlString.indexOf('video=');
    if (urlStart != -1) {
      final urlEnd = urlString.indexOf('&', urlStart + 1);
      if (urlEnd != -1) {
        return urlString.substring(urlStart + 6, urlEnd);
      } else {
        return urlString.substring(urlStart + 6);
      }
    }
    return null;
  }

  Future<void> _initUniLinks() async {
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                maintainState: false,
                builder: (context) => Video360Page(
                      initialLink: link,
                    )),
            (route) => false);
        dispose();
      }
    }, onError: (err) {
      if (kDebugMode) {
        print(err);
      }
    });
  }
}

class DurationBar extends StatelessWidget {
  final int? total, duration;
  final Video360Controller? controller;

  const DurationBar({
    super.key,
    this.total,
    this.duration,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      activeColor: Colors.orange,
      thumbColor: Colors.orange,
      min: 0,
      max: total?.toDouble() ?? 1000,
      value: duration?.toDouble() ?? 0,
      onChangeEnd: (double value) {
        if (duration != 0 && total != 0) {
          controller?.jumpTo(value);
        }
      },
      onChanged: (double value) {},
    );
  }
}
