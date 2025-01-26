import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:camera_image_selector/take_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

import 'ImageList.dart';
import 'image_controller.dart';

class CameraImageSelector extends StatefulWidget {
  final ImageController imageController;

  const CameraImageSelector({Key? key, required this.imageController})
      : super(key: key);

  @override
  _CameraImageSelectorState createState() => _CameraImageSelectorState();
}

class _CameraImageSelectorState extends State<CameraImageSelector> {
  int _selectedIndex = 0;

  Future<void> _pickImages() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          imageController: widget.imageController,
        ),
      ),
    ).then((value) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return ListenableBuilder(
          listenable: widget.imageController,
          builder: (context, child) {
            return Column(
              children: [
                if (widget.imageController.selectedImages.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        Image.memory(widget.imageController.selectedImages[_selectedIndex]),
                        Positioned(
                          child: IconButton(
                              icon: Icon(Icons.edit),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Colors.white.withOpacity(0.5)),
                              ),
                                onPressed: () async {
                                final editedImage = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => ImageEditor(
                                image: widget.imageController.selectedImages[_selectedIndex],
                                ),
                                ),
                                );

                                if (editedImage != null) {
                                setState(() {
                                widget.imageController.selectedImages[_selectedIndex] = editedImage;
                                });
                                widget.imageController.notifyListeners(); // Notify listeners of the change
                                }
                                },
                              ),
                        )
                      ],
                    ),
                  ),
                if (widget.imageController.selectedImages.isEmpty)
                  SizedBox(height: 200, child: Placeholder()),
                Container(
                  height: 100,
                  child: Row(
                    children: [
                      ListenableBuilder(
                        listenable: widget.imageController,
                        builder: (context, child) {
                          return ImageSortList(
                              selectedImages: widget.imageController.selectedImages,
                              onImageSelected: (index) {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                          );
                        },
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
          }
    );
  }
}