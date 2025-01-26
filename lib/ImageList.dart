import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageSortList extends StatefulWidget {
  final List<Uint8List> selectedImages;
  final ValueChanged<int>? onImageSelected;

  ImageSortList({Key? key, required this.selectedImages, this.onImageSelected}) : super(key: key);

  @override
  State<ImageSortList> createState() => _ImageSortListState();
}

class _ImageSortListState extends State<ImageSortList> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        scrollController: _scrollController,
        itemBuilder: buildItem,
        itemCount: widget.selectedImages.length,
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Uint8List item = widget.selectedImages.removeAt(oldIndex);
            widget.selectedImages.insert(newIndex, item);
          });
        },
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Stack(
      key: Key('$index'),
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
            if (widget.onImageSelected != null) {
              widget.onImageSelected!(index);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
              border: Border.all(
                color: _selectedIndex == index ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            margin: const EdgeInsets.all(4.0),
            child: Image.memory(widget.selectedImages[index],),
            ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.delete,),
            onPressed: () {
              setState(() {
                if (_selectedIndex > index) {
                  _selectedIndex -= 1;
                }
                widget.selectedImages.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }
}