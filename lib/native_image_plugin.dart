import 'dart:io';

import 'package:flutter/material.dart';

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
  final double width;
  final double height;
  final String? url;
  final String? path;

  const NativeImageView({
    Key? key,
    required this.width,
    required this.height,
    this.url,
    this.path,
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
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: UiKitView(
          viewType: "NativeImagePlugin",
          layoutDirection: TextDirection.ltr,
          creationParams: {
            'url': widget.url,
            'path': widget.path,
          },
          creationParamsCodec: const StandardMessageCodec(),
        ),
      );
    }
    return Container();
  }
}
