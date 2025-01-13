import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'camera_image_selector_platform_interface.dart';

/// An implementation of [CameraImageSelectorPlatform] that uses method channels.
class MethodChannelCameraImageSelector extends CameraImageSelectorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camera_image_selector');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
