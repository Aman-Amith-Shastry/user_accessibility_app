import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view_gallery.dart';

class imageGallery extends StatefulWidget {

  final List img_list;
  int pos;
  List<AssetEntity> entities;
  bool visible = false;
  bool canDel = false;

  imageGallery({
    required this.img_list,
    required this.pos,
    required this.entities
  });

  @override
  State<imageGallery> createState() => _imageGalleryState();
}

class _imageGalleryState extends State<imageGallery> {

  @override

  Widget build(BuildContext context) {

    int startPage = widget.pos;
    PageController _pageController = PageController(initialPage: startPage);

    return Scaffold(
      
      appBar: widget.visible?
        AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
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
          pageController: _pageController,
          
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

        duration: Duration(milliseconds: 100),

        child: BottomNavigationBar(

          onTap: (index) async{
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
              // setState(() {
              //   widget.pos -= 1;
              // });
            }
          },
          selectedItemColor: Colors.grey,
          unselectedItemColor: Colors.grey,

          items: [
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
      // bottomNavigationBar: Container(
      //   height: 0.1 * MediaQuery.of(context).size.height,
      //   child: Row(children: [

      //     Expanded(
      //       child: IconButton(
      //         onPressed: (){},
      //         icon: Icon(Icons.share),
      //       ),
      //     ),

      //     Expanded(
      //       child: IconButton(
      //         onPressed: (){},
      //         icon: Icon(Icons.delete),
      //       ),
      //     ),

      //   ]),
      // ),
    );
  }
}