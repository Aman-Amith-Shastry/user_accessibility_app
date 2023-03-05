import 'package:flutter/material.dart';
import 'package:user_accessibility_app/apps.dart';
import 'package:user_accessibility_app/contacts.dart';
import 'package:user_accessibility_app/docs.dart';
import 'package:user_accessibility_app/images.dart';
import 'package:user_accessibility_app/payments.dart';

Widget showNavBar(context){
  return Drawer(
    child: Column(
      children: [
        Container(
          height: 0.2 * MediaQuery.of(context).size.height,
          width: 0.8 * MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.purple
          ),
          child: const Center(
            child: Text(
              'Navigate easily',
              style: TextStyle(
                color: Colors.white
              ),
              ),
          )
          ),

        // Images
        buildListTile(context, 'My Images', Icons.image, const ImagePage()),
        const Divider(height: 10,),
    
        // Apps
        buildListTile(context, 'My Apps', Icons.apps, const AppPage()),
        const Divider(height: 10,),
    
        // Documents
        buildListTile(context, 'My Documents', Icons.file_present, const DocsPage()),
        const Divider(height: 10,),
    
        // Contacts
        buildListTile(context, 'My Contacts', Icons.contacts, const ContactsPage()),
        const Divider(height: 10,),

        // Payments
        buildListTile(context, 'My Payments', Icons.wallet, const PaymentPage()),
        const Divider(height: 10,),
      ],
    ),
  );
}

ListTile buildListTile(context, String text, leading, url){
  return ListTile(
    title: Text(
      text,
      style: const TextStyle(
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