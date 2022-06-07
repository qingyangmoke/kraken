import 'package:kraken/rendering.dart';

import 'media.dart';
import 'dart:ffi';
import 'dart:async';
import 'package:kraken/bridge.dart';
import 'package:kraken/css.dart';
import 'package:flutter/rendering.dart';
import 'package:kraken/dom.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/widgets.dart';

const Map<String, dynamic> _defaultStyle = {
  WIDTH: ELEMENT_DEFAULT_WIDTH,
  HEIGHT: ELEMENT_DEFAULT_HEIGHT,
};

const String VIDEO = 'VIDEO';

// 只能在真机测试 IOS模拟器无法播放
class VideoElement extends MediaElement {
  TextureBox _textureBox;

  VideoPlayerController controller;

  String get src => properties['src'] ?? '';

  bool get autoplay => properties.containsKey('autoplay');

  bool get loop => properties.containsKey('loop');

  double get currentTime {
    return controller != null ? controller.value.position.inSeconds : 0;
  }

  double get duration {
    return controller != null ? controller.value.duration.inSeconds : 0;
  }

  int get videoWidth {
    return controller != null ? controller.value.size.width : 0;
  }

  int get videoHeight {
    return controller != null ? controller.value.size.height : 0;
  }

  bool get isBuffering {
    return controller != null ? controller.value.isBuffering : false;
  }

  bool get isPlaying {
    return controller != null ? controller.value.isPlaying : false;
  }

  VideoElement(int targetId, Pointer<NativeMediaElement> nativePtr,
      ElementManager elementManager)
      : super(
          targetId,
          nativePtr,
          elementManager,
          VIDEO,
          defaultStyle: _defaultStyle,
        );

  @override
  void willAttachRenderer() {
    super.willAttachRenderer();
  }

  @override
  void didDetachRenderer() {
    super.didDetachRenderer();

    if (controller != null) {
      controller.dispose().then((_) {
        controller = null;
      });
    }
  }

  @override
  void play() {
    print('play');
    if (controller != null) {
      controller.play();
    }
  }

  @override
  void pause() {
    print('pause');
    if (controller != null) {
      controller.pause();
    }
  }

  @override
  void fastSeek(double duration) {
    print('fastSeek $duration');
    if (controller != null) {
      controller.seekTo(Duration(seconds: duration.toInt()));
    }
  }

  @override
  dynamic getProperty(String key) {
    switch (key) {
      case 'paused':
        return isPlaying;
      case 'duration':
        return duration;
      case 'currentTime':
        return currentTime;
      case 'videoWidth':
        return videoWidth;
      case 'videoHeight':
        return videoHeight;
      case 'value':
        return controller?.value.toString();
    }

    return super.getProperty(key);
  }

  @override
  void setProperty(String key, dynamic value) {
    var oldSrc = properties['src'] as String;
    super.setProperty(key, value);
    print('setProperty key=$key,value=$value');
    switch (key) {
      case 'src':
        var newSrc = value as String;
        if (controller != null && newSrc != oldSrc) {
          controller.dispose().then((_) {
            _removeVideoBox();
            _createVideoBox(newSrc);
          });
        } else {
          _createVideoBox(newSrc);
        }
        break;
    }
  }

  @override
  void removeProperty(String key) {
    super.removeProperty(key);
    switch (key) {
      case 'loop':
        controller?.setLooping(loop);
        break;
      case 'src':
        _removeVideoBox();
        break;
    }
  }

  void renderVideo() {
    _textureBox = TextureBox(textureId: 0);
    if (childNodes.isEmpty) {
      addChild(_textureBox);
    }
  }

  void addVideoBox(int textureId) {
    if (src.isEmpty) {
      return;
    }

    print('textureId=$textureId');

    TextureBox box = TextureBox(textureId: textureId);

    addChild(box);

    if (autoplay) {
      controller?.play();
    }
  }

  Future<int> createVideoPlayer(String src) {
    Completer<int> completer = Completer();

    if (src.startsWith('//') ||
        src.startsWith('http://') ||
        src.startsWith('https://')) {
      controller = VideoPlayerController.network(
          src.startsWith('//') ? 'https:' + src : src);
    }
    // else if (src.startsWith('file://')) {
    //   controller = VideoPlayerController.file(src);
    // } else {
    //   // Fallback to asset video
    //   controller = VideoPlayerController.asset(src);
    // }
    controller.setLooping(loop);
    // controller.onCanPlay = onCanPlay;
    // controller.onCanPlayThrough = onCanPlayThrough;
    // controller.onPlay = onPlay;
    // controller.onPause = onPause;
    // controller.onSeeked = onSeeked;
    // controller.onSeeking = onSeeking;
    // controller.onEnded = onEnded;
    // controller.onError = onError;
    controller.addListener(() {
      // _dispatchEvent('change');
      // print('addEventListener ${controller.value.toString()}');
      if (!controller.value.isPlaying &&
          controller.value.initialized &&
          (controller.value.duration == controller.value.position)) {
        onEnded();
      }
    });
    controller.initialize().then((_) {
      if (properties.containsKey('muted')) {
        controller.setVolume(0);
      }

      completer.complete(controller.textureId);
    });

    return completer.future;
  }

  void _createVideoBox(String src) {
    createVideoPlayer(src).then(addVideoBox);
  }

  void _removeVideoBox() {
    (renderBoxModel as RenderIntrinsic).child = null;
  }

  void _dispatchEvent(String eventName) {
    Event event = Event(eventName, EventInit());
    dispatchEvent(event);
  }

  void onPlay() {
    _dispatchEvent('play');
  }

  void onCanPlay() {
    _dispatchEvent('canplay');
  }

  void onCanPlayThrough() {
    _dispatchEvent('canplaythrough');
  }

  void onSeeked() {
    _dispatchEvent('seeked');
  }

  void onSeeking() {
    _dispatchEvent('seeking');
  }

  void onError() {
    _dispatchEvent('error');
  }

  void onEnded() {
    _dispatchEvent('ended');
  }

  void onPause() {
    _dispatchEvent('pause');
  }

  void onTimeUpdate() {
    _dispatchEvent('timeupdate');
  }
}
