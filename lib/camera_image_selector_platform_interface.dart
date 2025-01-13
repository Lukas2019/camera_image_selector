import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'camera_image_selector_method_channel.dart';

abstract class CameraImageSelectorPlatform extends PlatformInterface {
  /// Constructs a CameraImageSelectorPlatform.
  CameraImageSelectorPlatform() : super(token: _token);

  static final Object _token = Object();

  static CameraImageSelectorPlatform _instance = MethodChannelCameraImageSelector();

  /// The default instance of [CameraImageSelectorPlatform] to use.
  ///
  /// Defaults to [MethodChannelCameraImageSelector].
  static CameraImageSelectorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CameraImageSelectorPlatform] when
  /// they register themselves.
  static set instance(CameraImageSelectorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
