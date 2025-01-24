import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';

class CameraImageSelector extends StatefulWidget {
  @override
  _CameraImageSelectorState createState() => _CameraImageSelectorState();
}

class _CameraImageSelectorState extends State<CameraImageSelector> {
  final List<Uint8List> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  late CameraController controller;
  late List<CameraDescription> _cameras;

  int _selectedIndex = 0;

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      XFile image;
      for ( image  in images) {
        Uint8List imageAsBytes = await convertImagePathToBytes(image.path);
        setState(() {
          _selectedImages.add( imageAsBytes);
        });
      }
    }
  }

  Future<Uint8List> convertImagePathToBytes(String imagePath) async {
    final File imageFile = File(imagePath);
    return await imageFile.readAsBytes();
  }

  @override
  void initState() {
    super.initState();
    //cameraLoading();
  }

  cameraLoading() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Images'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: _pickImages,
          ),
        ],
      ),
      body: Column(
                children: [
                  if (_selectedImages.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          Image.memory(_selectedImages[_selectedIndex]),
                          Positioned(
                            child: IconButton(
                                icon: Icon(Icons.edit),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      Colors.white.withOpacity(0.5)),
                                ),
                                onPressed: () async {
                                  final image = await _selectedImages[_selectedIndex];
                                  final editedImage = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageEditor(
                                        image: image, // <-- Uint8List of image
                                      ),
                                    ),
                                  );

                                  if (editedImage != null) {
                                    setState(() {
                                      _selectedImages[_selectedIndex] =
                                          editedImage;
                                    });
                                  }
                                }),
                          )
                        ],
                      ),
                    ),
                  if (_selectedImages.isEmpty)
                    SizedBox(height: 200, child: Placeholder()),
                  Container(
                    height: 100,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 50,
                          child: ReorderableListView.builder(
                            scrollDirection: Axis.horizontal,
                            scrollController: _scrollController,
                            itemBuilder: buildItem,
                            itemCount: _selectedImages.length,
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final Uint8List item =
                                    _selectedImages.removeAt(oldIndex);
                                _selectedImages.insert(newIndex, item);
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: _pickImages,
                        ),
                      ],
                    ),
                  ),
                ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Stack(key: Key('$index'), children: [
      GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          margin: const EdgeInsets.all(8.0),
          height: 100,
          width: 100,
          child: Center(child: Image.memory(_selectedImages[index])),
        ),
      ),
      Positioned(
        child: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              if (_selectedIndex > index) {
                _selectedIndex -= 1;
              }
              _selectedImages.removeAt(index);
            });
          },
        ),
        top: 0,
        right: 0,
      ),
    ]);
  }
}