import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:camera/camera.dart';



class CameraImageSelector extends StatefulWidget {
  @override
  _CameraImageSelectorState createState() => _CameraImageSelectorState();
}

class _CameraImageSelectorState extends State<CameraImageSelector> {
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  late CameraController controller;
  late List<CameraDescription> _cameras;

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  @override
  void initState()  {
    super.initState();
    cameraLoading();
  }

  cameraLoading() async{
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
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
      body: _selectedImages.isEmpty
          ? Center(child: Text('No images selected.'))
          : SizedBox(
              height: 100,
            child: Scrollbar(
              controller: _scrollController,
              child:  ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                scrollController: _scrollController,
                itemBuilder: buildItem,
                itemCount: _selectedImages.length,
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final XFile item = _selectedImages.removeAt(oldIndex);
                    _selectedImages.insert(newIndex, item);
                  });
                },
              ),
            ),
          ),
    );
  }
  Widget buildItem(context, index) {
    return Container(
      key: Key('$index'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      margin: const EdgeInsets.all(8.0),
      height: 100,
      width: 100,
      child: Center(child: Image.file(File(_selectedImages[index].path))),
    );
  }

}

