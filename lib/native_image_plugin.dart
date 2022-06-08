import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class NativeImagePlugin {
  static const MethodChannel _channel = MethodChannel('native_image_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}

class NativeImageView extends StatefulWidget {
  final double? width;
  final double? height;
  final String? url;
  final String? path;
  final Uint8List? bytes;
  final BoxFit? fit;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
  final PlatformViewHitTestBehavior hitTestBehavior;

  const NativeImageView({
    Key? key,
    required this.width,
    required this.height,
    this.url,
    this.path,
    this.bytes,
    this.fit,
    this.gestureRecognizers,
    this.hitTestBehavior = PlatformViewHitTestBehavior.opaque,
  }) : super(key: key);

  @override
  _NativeImageViewState createState() {
    return _NativeImageViewState();
  }
}

class _NativeImageViewState extends State<NativeImageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      String fitString = "";
      switch (widget.fit) {
        case BoxFit.cover:
          fitString = "cover";
          break;
        case BoxFit.fill:
          fitString = "fill";
          break;
        case BoxFit.contain:
          fitString = "contain";
          break;
      }
      var _image = UiKitView(
        // key: UniqueKey(),
        viewType: "native_image_view",
        layoutDirection: TextDirection.ltr,
        hitTestBehavior: widget.hitTestBehavior,
        gestureRecognizers: widget.gestureRecognizers,
        creationParams: {
          'url': widget.url,
          'path': widget.path,
          'data': widget.bytes,
          'fit': fitString,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
      if ((widget.width ?? widget.height) !=null) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: _image,
        );
      } else {
        return _image;
      }
    }
    return Container();
  }
}
