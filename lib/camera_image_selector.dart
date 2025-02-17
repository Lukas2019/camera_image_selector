import 'package:camera_image_selector/take_picture_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

import 'ImageList.dart';
import 'image_controller.dart';

class CameraImageSelector extends StatefulWidget {

  static void registerWith() {
    // Registration logic if needed.
  }

  final ImageController imageController;

  const CameraImageSelector({Key? key, required this.imageController})
      : super(key: key);

  @override
  _CameraImageSelectorState createState() => _CameraImageSelectorState();
}

class _CameraImageSelectorState extends State<CameraImageSelector> {
  int _selectedIndex = 0;

  Future<void> _pickImages() async {
    await Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          imageController: widget.imageController,
        ),
      ),
    )
        .then((value) {
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
                      Image.memory(widget
                          .imageController.selectedImages[_selectedIndex]),
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
                                  image: widget.imageController
                                      .selectedImages[_selectedIndex],
                                ),
                              ),
                            );

                            if (editedImage != null) {
                              setState(() {
                                widget.imageController
                                        .selectedImages[_selectedIndex] =
                                    editedImage;
                              });
                              widget.imageController
                                  .notifyListeners(); // Notify listeners of the change
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              if (widget.imageController.selectedImages.isEmpty)
                Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                    height: 190,
                    child: Center(
                        child: IconButton(
                          onPressed: _pickImages,
                          icon: const Column(
                                                children: [
                          Icon(Icons.add_a_photo, size: 120,),
                          Text(
                            'Kein Bild ausgewählt füge ein Bild hinzu.',
                          ),
                                                ],
                                              ),
                        ))),
              Container(
                height: 100,
                child: Row(
                  children: [
                    widget.imageController.selectedImages.isNotEmpty
                        ? ListenableBuilder(
                            listenable: widget.imageController,
                            builder: (context, child) {
                              return ImageSortList(
                                selectedImages:
                                    widget.imageController,
                                onImageSelected: (index) {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                              );
                            },
                          )
                        : Expanded(
                            child: Center(
                              child: IconButton(
                                  onPressed: _pickImages,
                                  icon: const Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      Icon(Icons.add_a_photo),
                                      SizedBox(width: 10),
                                      Text('Bild hinzufügen'),
                                    ],
                                  )),
                            )),
                    if(widget.imageController.selectedImages.isNotEmpty) IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: _pickImages,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
