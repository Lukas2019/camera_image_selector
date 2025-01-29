# camera_image_selector

A Flutter plugin for iOS and Android for picking images from the image library, and taking new pictures with the camera.

## Features

- Pick images from the image library.
- Take new pictures with the camera.
- Edit Images
- Sort Images

## Installation

First, add `camera_image_selector` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

'''yaml'
dependencies:
  camera_image_selector: ^0.0.1
'''
## Usage

'''dart'
import 'package:camera_image_selector/camera_image_selector.dart';
import 'package:camera_image_selector/image_controller.dart';
'''

'''dart'
final ImageController _imageController = ImageController();
'''

'''dart'
CameraImageSelector(imageController: _imageController,)
'''

### iOS

Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryUsageDescription` - describe why your app needs permission for the photo library. This is called _Privacy - Photo Library Usage Description_ in the visual editor.
* `NSCameraUsageDescription` - describe why your app needs access to the camera. This is called _Privacy - Camera Usage Description_ in the visual editor.
* `NSMicrophoneUsageDescription` - describe why your app needs access to the microphone, if you intend to record videos. This is called _Privacy - Microphone Usage Description_ in the visual editor.

Or in text format add the key:

``` xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
<key>NSCameraUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
<key>NSMicrophoneUsageDescription</key>
<string>Used to capture audio for image picker plugin</string>
```

### Android

You must update minSdkVersion to 21 (or higher) in your `android/app/build.gradle` file.