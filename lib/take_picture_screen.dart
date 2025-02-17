import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:camera_image_selector/ImageList.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';  // Add this import
import 'helper.dart';
import 'image_controller.dart';

class TakePictureScreen extends StatefulWidget {
  final ImageController imageController;

  const TakePictureScreen({
    super.key,
    required this.imageController,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _controller;  // Make nullable
  Future<void>? _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();
  List<CameraDescription> _cameras = [];  // Initialize with empty list
  int _selectedCamera = 0;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await _setupCamera();
    } else {
      debugPrint('Camera permission denied');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();  // Safe disposal
    super.dispose();
  }

  Future<void> _setupCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        debugPrint('No cameras available');
        return;
      }

      final camera = _cameras[_selectedCamera];
      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // Initialize in two steps to handle errors better
      _controller = controller;
      _initializeControllerFuture = controller.initialize().then((_) {
        if (mounted) setState(() {});
      }).catchError((e) {
        debugPrint('Camera initialization error: $e');
        _controller = null;
        if (mounted) setState(() {});
      });
    } catch (e) {
      debugPrint('Camera setup error: $e');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.isEmpty) return;
    
    try {
      await _controller?.dispose();
      setState(() {
        _selectedCamera = (_selectedCamera + 1) % _cameras.length;
        _controller = CameraController(
          _cameras[_selectedCamera],
          ResolutionPreset.medium,
          enableAudio: false,
        );
        _initializeControllerFuture = _controller?.initialize();
      });
    } catch (e) {
      debugPrint('Error switching camera: $e');
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      debugPrint('Error: Camera not initialized');
      return;
    }

    try {
      await _initializeControllerFuture;
      
      // Prevent screen rotation during capture
      await _controller!.lockCaptureOrientation();
      
      final XFile image = await _controller!.takePicture();
      if (!mounted) return;

      final imageBytes = await convertImagePathToBytes(image.path);
      widget.imageController.addImage(imageBytes);
    } catch (e) {
      debugPrint('Error capturing image: $e');
    } finally {
      if (mounted) {
        // Reset orientation after capture
        await _controller!.unlockCaptureOrientation();
      }
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && mounted) {
        for (final image in images) {
          final imageBytes = await convertImagePathToBytes(image.path);
          widget.imageController.addImage(imageBytes);
        }
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Mach ein Bild'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('fertig', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (_controller == null) {
                    return const Center(
                      child: Text(
                        'Camera initialization failed',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done && 
                      _controller!.value.isInitialized) {
                    return ClipRect(
                      child: AspectRatio(
                        aspectRatio: 1 / _controller!.value.aspectRatio,
                        child: CameraPreview(_controller!),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  if (_cameras.isEmpty) {
                    return const Center(
                      child: Text(
                        'No cameras available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            ListenableBuilder(
              listenable: widget.imageController,
              builder: (context, _) => SizedBox(
                height: 100,
                child: ImageSortList(selectedImages: widget.imageController),
              ),
            ),
            Container(
              color: Colors.white12,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.outlined(
                    onPressed: _pickImages,
                    icon: const Row(
                      children: [
                        Icon(Icons.image, color: Colors.white, size: 32),
                        Text('Bilder', style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _captureImage,
                      icon: const Icon(Icons.camera, color: Colors.black, size: 40),
                    ),
                  ),
                  IconButton.outlined(
                    onPressed: _switchCamera,
                    icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
