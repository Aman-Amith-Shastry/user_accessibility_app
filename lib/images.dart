// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:share/share.dart';
import 'package:user_accessibility_app/image_gallery.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:device_apps/device_apps.dart';

void main(){
  runApp(const MaterialApp(
    home: ImagePage(),
    debugShowCheckedModeBanner: false,
  ));
}


class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {

  bool _isloading = true;
  List createdDates = [];
  List dayList = [];
  List<AssetEntity> entity_list = [];
  List<FileSystemEntity> sortedImages = [];
  List<String> sortedAsString = [];
  Map<DateTime, FileSystemEntity> mapImages = {};

  Future<void> _getImages() async{
    List dirList = [];
    var storageInfo = await PathProviderEx.getStorageInfo();
    List extensions = ['jpg', 'png', 'jpeg', 'bmp'];
    var _ps = await Permission.storage.request();
    if (_ps.isGranted) {
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();

      for(AssetPathEntity path in paths){
        List<AssetEntity> entities = await path.getAssetListRange(start: 0, end: 500);
            setState(() {
              entity_list = entities;
              _isloading = false;
            });
          
        for(AssetEntity entity in entities){
          
          final AssetEntity? asset = await AssetEntity.fromId(entity.id);
          if(dirList.contains("${storageInfo[0].rootDir}/${asset!.relativePath!}") == false && (asset.relativePath!.endsWith('.jpg') || asset.relativePath!.endsWith('.png') || asset.relativePath!.endsWith('.jpeg')) == false && asset.relativePath!.startsWith('/storage') == false){
            dirList.add("${storageInfo[0].rootDir}/${asset.relativePath!}");
          }

          else{
            dirList.add(asset.relativePath);
          }
        }
        for(var dir in dirList){
          Directory actDir = Directory(dir);
          List<FileSystemEntity> files = actDir.listSync();
          for(FileSystemEntity file in files){
            if(extensions.contains(file.absolute.path.split('.')[1]) == true){
              setState(() {
                mapImages[file.statSync().changed] = file;
              });
            }
          }
        }
        Map<DateTime, FileSystemEntity> sortedMap = Map.fromEntries(
          mapImages.entries.toList()
          ..sort(((a, b) => a.key.compareTo(b.key)))
        );


        sortedImages = sortedMap.values.toList().reversed.toList();
        for(FileSystemEntity image in sortedImages){
          setState(() {
            sortedAsString.add(image.absolute.path);
          });
        }
      }
    } else {
      PhotoManager.openSetting();
    }
  }


  void initState(){
    _getImages();
    super.initState();
  }
  
  @override

  Widget build(BuildContext context) {
    List<String> imagePaths = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Images"),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new)
          ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            onPressed: (){
              DeviceApps.openApp('com.sec.android.app.camera');
            },
            icon: const Icon(Icons.camera_alt_outlined)),
          IconButton(
            onPressed: () async{
              final List<XFile>? images = await ImagePicker().pickMultiImage();
              if(images == null) return;
              for(XFile image in images){
                setState(() {
                  imagePaths.add(image.path);
                });
              }
              Share.shareFiles(imagePaths);
            },
            icon: const Icon(Icons.share))
        ],
      ),

      body: sortedImages.isEmpty? const Center(
        child: CircularProgressIndicator(),
      ):
      Padding(
        padding: const EdgeInsets.only(top: 10),
      child: RefreshIndicator(
        onRefresh: _getImages,
        child: showImages(sortedImages, context, entity_list)
        ),
    ),

    );
  }
}

Widget showImages(List<FileSystemEntity> files, BuildContext context, List<AssetEntity> entity_list){
  return GridView.builder(
    itemCount: files.length,
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: MediaQuery.of(context).size.width),
    itemBuilder: (context, index){
      return InkWell(
        child: Image.file(
          File(files[index].absolute.path),
          width: MediaQuery.of(context).size.width,
          fit:BoxFit.fitWidth
          ),
          onTap: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: ((context) => ImageGallery(img_list: files, pos: index, entities: entity_list))
                )
              );
          },
      );
    });
}