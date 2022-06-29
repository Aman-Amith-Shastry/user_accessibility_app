import 'package:flutter/material.dart';
import 'package:user_accessibility_app/apps.dart';
import 'package:user_accessibility_app/contacts.dart';
import 'package:user_accessibility_app/docs.dart';
import 'package:user_accessibility_app/images.dart';

Widget showNavBar(context){
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.purple
          ),
          child: Text(
            'Navigate easily',
            style: TextStyle(
              color: Colors.white
            ),
            )
          ),

        // Images
        buildListTile(context, 'My Images', Icons.image, ImagePage()),
        Divider(height: 10,),

        // Apps
        buildListTile(context, 'My Apps', Icons.apps, AppPage()),
        Divider(height: 10,),

        // Documents
        buildListTile(context, 'My Documents', Icons.file_present, DocsPage()),
        Divider(height: 10,),

        // Contacts
        buildListTile(context, 'My Contacts', Icons.contacts, ContactsPage()),
        Divider(height: 10,),
      ],
    ),
  );
}

ListTile buildListTile(context, String text, leading, url){
  return ListTile(
    title: Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: Colors.grey
      ),
      ),
    leading: Icon(leading, size: 30),
    onTap: (){
      Navigator.pop(context);
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (BuildContext context) =>  url
          ),
          );
    },
  );
}