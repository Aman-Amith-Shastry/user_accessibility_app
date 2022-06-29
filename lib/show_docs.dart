import 'dart:io';

import 'package:flutter/material.dart';

import 'package:pdf_render/pdf_render_widgets.dart';

class showDocs extends StatefulWidget {

  showDocs({required this.path});
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
      ),
      backgroundColor: Colors.grey,
      body: Container(
        child: PdfViewer.openFile(widget.path),
      )
    );
  }
}