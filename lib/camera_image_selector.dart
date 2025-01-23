import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';

class CameraImageSelector extends StatefulWidget {
  @override
  _CameraImageSelectorState createState() => _CameraImageSelectorState();
}

class _CameraImageSelectorState extends State<CameraImageSelector> {
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  late CameraController controller;
  late List<CameraDescription> _cameras;

  int _selectedIndex = 0;

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
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
      body: FutureBuilder(
          future: _imagesLoading(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Column(
                children: [
                  if (_selectedImages.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          if (snapshot.hasData) Image(
                              image:
                                snapshot.data,
                                  ),
                          Positioned(
                            child: IconButton(
                                icon: Icon(Icons.edit),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      Colors.white.withOpacity(0.5)),
                                ),
                                onPressed: () async {
                                  final image = await File(
                                          _selectedImages[_selectedIndex].path)
                                      .readAsBytes();
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
                                          XFile.fromData(editedImage);
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
                                final XFile item =
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
              );
          }),
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
          child: Center(child: Image.file(File(_selectedImages[index].path))),
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

  Future<dynamic> _imagesLoading() async {
    if (_selectedImages.isEmpty) {
      return null;
    }
    if (_selectedImages[_selectedIndex].path != "") {
      return FileImage(File(_selectedImages[_selectedIndex].path));
    }

    return FileImage( _selectedImages[_selectedIndex].readAsBytes());
  }
}
