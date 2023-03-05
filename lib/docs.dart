// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
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
  bool isGrid = true;

    Future<void> getFiles() async {
      List getDirs = [];
      List<String> showPdfs = [];
      var storageInfo = await PathProviderEx.getStorageInfo();
      var ps = await Permission.storage.request();
      Directory root = Directory(storageInfo[0].rootDir); //storageInfo[1] for SD card, geting the root directory

      getDirs = root.listSync();

      for(FileSystemEntity dir in getDirs){
        List<FileSystemEntity> file_list = Directory(dir.path).listSync();
        for(FileSystemEntity file in file_list){
          if(file.path.endsWith('.pdf')){
            setState(() {
              files.add(file.path);
            });
          }
        }
      }
  }

  void initState(){
    getFiles();
    super.initState();
  }


  @override
  
  Widget build(BuildContext context) {

    List<String?> pickedFiles = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Documents"),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new)
          ),
        backgroundColor: Colors.purple,
              
        actions: [
          IconButton(
            icon: Icon(
              !isGrid? Icons.grid_on
              : Icons.list
            ),
            onPressed: (){
              setState(() {
                isGrid = !isGrid;
              });
            },
            ),

          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context, 
                delegate: MySearchDelegate(files));
            },
            ),

            IconButton(
            onPressed: () async{
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                allowMultiple: true, 
                type: FileType.custom,
                allowedExtensions: ['pdf']);

                setState(() {
                  if (result != null) {
                    pickedFiles = result.paths;
                  }
                });

                Share.shareFiles(pickedFiles);
            },
            icon: const Icon(Icons.share)),
      ],
      ),

      body: files.isEmpty? const Center(child: CircularProgressIndicator())
      :
      isGrid?  Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: RefreshIndicator(
          onRefresh: getFiles,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2
                ),
              itemCount: files.length,
              itemBuilder: (context, index){
                return showFiles(context, files, index, isGrid);
              }),
        ),
      )
      :Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: RefreshIndicator(
          onRefresh: getFiles,
          child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index){
                return showFiles(context, files, index, isGrid);
              }),
        ),
      )

    );
  }
}

class MySearchDelegate extends SearchDelegate{
  MySearchDelegate(this.files);

  List<String> files = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(
      icon: const Icon(Icons.clear),
      onPressed: (){
        if(query.isEmpty){
          close(context, null);
        }
        query = '';
      },
      )];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List<String> suggestions = files.where((element){
      final result = element.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList() ;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2
        ),
      itemCount: suggestions.length,
      itemBuilder: ((context, index) {
        return showFiles(context, suggestions, index, false);
      })
      );
  }
}

Widget showFiles(context, files, index, isGrid){
  return ListTile(
    title: 
      isGrid? const Icon(Icons.picture_as_pdf)
      : Text(files[index].split('/').last),

    subtitle: isGrid? Text(files[index].split('/').last)
      : const Text(""),

    leading: isGrid? null
      :const Icon(Icons.picture_as_pdf),

    onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>  showDocs(path: files[index])
          ),
        );
    },
  );
}