import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user_accessibility_app/show_docs.dart';


void main() async{

  runApp(const MaterialApp(
    home: DocsPage(),
    debugShowCheckedModeBanner: false,
  ));
}


class DocsPage extends StatefulWidget {
  const DocsPage({Key? key}) : super(key: key);

  @override
  State<DocsPage> createState() => _DocsPageState();
}

class _DocsPageState extends State<DocsPage> {

  List<String> files = [];

    void getFiles() async {
      List<File> getPdfs = [];
      List<String> showPdfs = [];
      var ps = await Permission.storage.request();
      print(ps.isGranted);
      if(ps.isGranted){
        List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
        var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
        var fm = FileManager(root: Directory(root)); //
        getPdfs = await fm.filesTree( 
          // excludedPaths: ["/storage/emulated/0/Android"],
          extensions: ["pdf"] //optional, to filter files, list only pdf files
        );

        for(File file in getPdfs){
          if(showPdfs.contains(Text(file.path)) == false){
            setState(() {
              showPdfs.add(file.path);
            });
          }
        }
        setState(() {
          files = showPdfs;
        });
      }
  }

  @override

  Widget build(BuildContext context) {

    getFiles();
    return Scaffold(
      appBar: AppBar(
        title: Text("Documents"),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new)
          ),
        backgroundColor: Colors.purple,
      ),

      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
          ),
        itemCount: files.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Icon(Icons.picture_as_pdf),
            subtitle: Text(files[index].split('/').last),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>  showDocs(path: files[index],)
                  ),
                );
            },
          );
        })

    );
  }
}