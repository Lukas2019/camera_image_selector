# camera_image_selector

A Flutter plugin for iOS and Android enabling image selection from the device's image library and capturing new images using the camera.  The plugin also allows for basic image editing and sorting of selected images.


## Features

* Pick images from the device's image library.
* Take new pictures with the device's camera.
* Edit images using `image_editor_plus`.
* Reorder and delete selected images.


## Installation

Add `camera_image_selector` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  camera_image_selector: ^0.0.1
```

Run `flutter pub get` in your terminal to install the package.


## Usage

Import the necessary packages:

```dart
import 'package:camera_image_selector/camera_image_selector.dart';
import 'package:camera_image_selector/image_controller.dart';
```

Create an instance of `ImageController`:

```dart
final ImageController _imageController = ImageController();
```

Use the `CameraImageSelector` widget in your Flutter application, providing the `ImageController`:

```dart
CameraImageSelector(imageController: _imageController)
```

### iOS Configuration

Add the following keys to your `Info.plist` file (located at `<project root>/ios/Runner/Info.plist`):

* `NSPhotoLibraryUsageDescription` - Explain why your app needs access to the photo library.
* `NSCameraUsageDescription` - Explain why your app needs access to the camera.
* `NSMicrophoneUsageDescription` - Explain why your app needs access to the microphone (if recording videos).

Example (in XML):

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
<key>NSCameraUsageDescription</key>
<string>Used to demonstrate image picker plugin</string>
<key>NSMicrophoneUsageDescription</key>
<string>Used to capture audio for image picker plugin</string>
```

### Android Configuration

Update your `android/app/build.gradle` file to set `minSdk` to 21 or higher:

```gradle
android {
    defaultConfig {
        minSdk = 21
    }
}
```


## Technologies Used

* **Flutter:** The cross-platform UI framework.
* **Dart:** The programming language used for Flutter development.
* **image_picker:** Package for accessing the device's image library and camera.
* **camera:** Package for direct camera access and control.
* **image_editor_plus:** Package for image editing functionalities.
* **path_provider:** Used for managing file paths (indirectly through `image_picker` and `camera`).
* **Kotlin:** Used for the Android native implementation of the plugin.
* **Swift:** Used for the iOS native implementation of the plugin.


## Dependencies

* `camera`
* `image_picker`
* `image_editor_plus`
* `path_provider` (indirect)


## Contributing

Contributions are welcome! Please open an issue or submit a pull request.


## Testing

Unit tests are included for the Android native plugin code.  Further testing for the Flutter part of the plugin is recommended.


## License

Copyright 2025 Lukas2019

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



*README.md was made with [Etchr](https://etchr.dev)*