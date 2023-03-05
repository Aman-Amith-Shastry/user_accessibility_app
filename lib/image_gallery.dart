// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';

class ImageGallery extends StatefulWidget {

  final List img_list;
  int pos;
  List<AssetEntity> entities;
  bool visible = false;
  bool canDel = false;

  ImageGallery({Key? key, 
    required this.img_list,
    required this.pos,
    required this.entities
  }) : super(key: key);

  @override
  State<ImageGallery> createState() => _imageGalleryState();
}

class _imageGalleryState extends State<ImageGallery> {

  @override

  Widget build(BuildContext context) {

    int startPage = widget.pos;
    PageController pageController = PageController(initialPage: startPage);

    return Scaffold(
      
      appBar: widget.visible?
        AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey,
              )
            ),
        ): null,

      body: InkWell(

        onTap: (){
          setState(() {
            widget.visible = !widget.visible;
          });
        },

        child: PhotoViewGallery.builder(
          itemCount: widget.img_list.length,
          pageController: pageController,
          
          builder: (context, index){
            final img = widget.img_list[index];
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(img),
              );
          },
          onPageChanged: (index){
            setState((){
              widget.pos = index;
            });
          },
        ),
      ),

      bottomNavigationBar: AnimatedContainer(

        height: widget.visible? kBottomNavigationBarHeight: 0,

        duration: const Duration(milliseconds: 50),

        child: BottomNavigationBar(

          onTap: (index) async{
            if(index == 0){
              Share.shareFiles([widget.img_list[widget.pos].toString().substring(7).split("'")[0]]);
            }
            if(index == 1){
              print("Index: ${widget.pos}");
              print("File: ${widget.img_list[widget.pos]}");
              var stor = await Permission.storage.request();
              var loc = await Permission.accessMediaLocation.request();
              if(stor.isGranted && loc.isGranted){
                print("Granted");
                widget.img_list[widget.pos].delete();
              }

              setState(() {
                widget.img_list.remove(widget.img_list[widget.pos]);
              });
            }
          },
          selectedItemColor: Colors.grey,
          unselectedItemColor: Colors.grey,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.share),
              label: "Share"
              ),
      
            BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              label: "Delete"
              ),
      
            ]
          ),
      ),
    );
  }
}