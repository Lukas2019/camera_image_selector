import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:camera_image_selector/ImageList.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'helper.dart';
import 'image_controller.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  //final ValueChanged onPictureTaken;
  final ImageController imageController;

  TakePictureScreen({
    super.key,
    required this.imageController,
    //required this.onPictureTaken,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void>? _initializeControllerFuture = null;
  final ImagePicker _picker = ImagePicker();
  late List<CameraDescription> _cameras;
  int _selectedCamera = 0;


  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<void> _setupCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(_cameras[0], ResolutionPreset.max);
      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture; // Wait for initialization
      setState(() {}); // Update UI after initialization
    } catch (e) {
      print('Error initializing camera: $e');
      // Handle error, e.g., show an error message
    }
  }

  void _captureImage() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();

      if (!context.mounted) return;

      final imageBytes = await convertImagePathToBytes(image.path);
      setState(() {
        widget.imageController.addImage(imageBytes);
      });
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  void pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      XFile image;
      for (image in images) {
        Uint8List imageAsBytes = await convertImagePathToBytes(image.path);
        setState(() {
          widget.imageController.addImage(imageAsBytes);
        });
      }
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
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'fertig',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Placeholder(strokeWidth: 0,
            color: Colors.black,),),
FutureBuilder<void>(
  future: _initializeControllerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return CameraPreview(_controller);
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    else if (snapshot.hasError) {
      return const Center(child: Text('Error loading camera'));
    } else {
      return const Center(child: Text('Unknown state'));
    }
  },
),
          Positioned(
            bottom: 0,
            left: 0,
            child: Expanded(
              child: Column(
                children: [
                  SizedBox(
                      height: 100,
                      child: ListenableBuilder(
                        listenable: widget.imageController,
                        builder: (context, child) {
                          return ImageSortList(selectedImages: widget.imageController);
                        },
                      ),
                  ),
                  Container(
                    color: Colors.white12,
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 100,
                          child: IconButton(
                              onPressed: () async {
                                final List<XFile>? images =
                                    await _picker.pickMultiImage();
                                if (images != null) {
                                  XFile image;
                                  for (image in images) {
                                    final imageBytes =
                                        await convertImagePathToBytes(image.path);
                                    setState(() {
                                      widget.imageController.addImage(imageBytes);
                                    });
                                  }
                                }
                              },
                              icon: Row(
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  Text(
                                    'Bilder',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              )),
                        ),
                        SizedBox(
                          width: 100,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                                onPressed: _captureImage,
                                icon: Icon(
                                  Icons.camera,
                                  color: Colors.black,
                                  size: 40,
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: IconButton(
                              onPressed: () {
                                _controller.dispose();
                                if (_cameras.length > _selectedCamera + 1) {
                                  _selectedCamera++;
                                } else {
                                  _selectedCamera = 0;
                                }
                                _controller = CameraController(_cameras[ _selectedCamera], ResolutionPreset.max);
                                _initializeControllerFuture = _controller.initialize();
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.cameraswitch,
                                color: Colors.white,
                                size: 32,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
