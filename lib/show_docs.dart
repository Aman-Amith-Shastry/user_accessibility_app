// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';

import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:share/share.dart';

class showDocs extends StatefulWidget {

  showDocs({Key? key, required this.path}) : super(key: key);
  String path = '';

  @override
  State<showDocs> createState() => _showDocsState();
}

class _showDocsState extends State<showDocs> {
  @override
  Widget build(BuildContext context) {
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

        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.shareFiles([widget.path]);
            },
          )
        ],
      ),
      backgroundColor: Colors.grey,
      body: PdfViewer.openFile(widget.path)
    );
  }
}