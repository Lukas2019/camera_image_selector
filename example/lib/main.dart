import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:camera_image_selector/camera_image_selector.dart';
import 'package:camera_image_selector/image_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final ImageController _imageController = ImageController();
  //late final CameraImageSelector _cameraImageSelectorPlugin;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    //_cameraImageSelectorPlugin = CameraImageSelector(imageController: _imageController);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // Initialize platform version

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = 'platformVersion';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Bilder selector"),
          actions: [
            IconButton(onPressed: (){
              _imageController.clearImages();
            }, icon: Icon(Icons.remove_circle)),
          ],
        ),
          body: CameraImageSelector(imageController: _imageController,)),
    );
  }
}