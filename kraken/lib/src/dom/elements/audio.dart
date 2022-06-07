import 'media.dart';
import 'dart:ffi';
import 'dart:async';
import 'package:kraken/bridge.dart';
import 'package:kraken/css.dart';
import 'package:kraken/dom.dart';

const Map<String, dynamic> _defaultStyle = {
  WIDTH: ELEMENT_DEFAULT_WIDTH,
  HEIGHT: ELEMENT_DEFAULT_HEIGHT,
};

const String AUDIO = 'AUDIO';

// 只能在真机测试 IOS模拟器无法播放
class AudioElement extends MediaElement {
  String get src => properties['src'] ?? '';

  bool get autoplay => properties.containsKey('autoplay');

  bool get loop => properties.containsKey('loop'); 

  AudioElement(int targetId, Pointer<NativeMediaElement> nativePtr,
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
  }

  @override
  void play() {
    print('play');
  }

  @override
  void pause() {
    print('pause');
  }

  @override
  void fastSeek(double duration) {
    print('fastSeek $duration');
  }

  @override
  dynamic getProperty(String key) {
    print('getProperty key=$key');
    return super.getProperty(key);
  }

  @override
  void setProperty(String key, dynamic value) {
    super.setProperty(key, value);
    print('setProperty key=$key,value=$value');
  }

  @override
  void removeProperty(String key) {
    super.removeProperty(key);
    print('removeProperty key=$key');
  }

}
