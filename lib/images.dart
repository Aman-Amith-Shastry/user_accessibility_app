import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:user_accessibility_app/image_gallery.dart';

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
  List img_list = [];
  List<AssetEntity> entity_list = [];

  Future<void> _getImages() async{
    List dir_list = [];

    var _ps = await Permission.storage.request();
    if (_ps.isGranted) {
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();

      for(AssetPathEntity path in paths){

        List<AssetEntity> entities = await path.getAssetListPaged(page: 0, size: 80);
            setState(() {
              entity_list = entities;
              _isloading = false;
            });
          
        
        for(AssetEntity entity in entities){
          
          final AssetEntity? asset = await AssetEntity.fromId(entity.id);
          if(dir_list.contains(asset!.relativePath!) == false){
            dir_list.add(asset.relativePath!);
          }
        }
        
        for(var dir in dir_list){
          Directory act_dir = Directory(dir);
          List files = act_dir.listSync();
            return setState(() {
              img_list = files;
            });
        }
  
      }
    } else {
      PhotoManager.openSetting();
    }
  }

  
  @override

  Widget build(BuildContext context) {

    _getImages();

    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new)
          ),
        backgroundColor: Colors.purple,
      ),

      body:_isloading? Center(
        child: CircularProgressIndicator(),
      ):
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: GridView.builder(

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 0.05 * MediaQuery.of(context).size.width,
            mainAxisSpacing: 0.1 * MediaQuery.of(context).size.height
          ),
          itemCount: img_list.length,
          itemBuilder: ((context, index) {
            String split_str = img_list[index].toString().split(".")[0];
            String name = split_str.split("/").last;

            return ListTile(
              title: Image.file(img_list[index],),
              subtitle: Text(name),
              
              onTap: () => Navigator.push(
                context, MaterialPageRoute(
                    builder: (BuildContext context) =>  imageGallery(img_list: img_list, pos: index, entities: entity_list)
                  ),),

              onLongPress: () async{
                var stor = await Permission.storage.request();
                var loc = await Permission.accessMediaLocation.request();
                if(stor.isGranted && loc.isGranted){
                  img_list[index].delete();
                  print("Deleted");
                }
              },
            );
          })
          )
      ),

    );
  }

}