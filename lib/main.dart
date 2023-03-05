import 'package:flutter/material.dart';
import 'package:user_accessibility_app/apps.dart';
import 'package:user_accessibility_app/contacts.dart';
import 'package:user_accessibility_app/docs.dart';
import 'package:user_accessibility_app/images.dart';
import 'package:user_accessibility_app/nav_bar.dart';
import 'package:user_accessibility_app/payments.dart';

void main() async{
  runApp(const MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List imageData = [];


  @override

  Widget build(BuildContext context) {
    Map titles = {
      "Images": [const ImagePage(), 'images/images.jpeg'],
      "Apps": [const AppPage(), 'images/apps.jpeg'],
      "Documents": [const DocsPage(), 'images/docs.jpeg'],
      "Contacts": [const ContactsPage(), 'images/contacts.jpeg'],
      "Payments": [const PaymentPage(), 'images/payments.png'] 
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Navigator app"),
        backgroundColor: Colors.purple,
      ),

      drawer: showNavBar(context),

      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
          ),
        itemCount: titles.length,
        itemBuilder: ((context, index) {
          return Card(
            child: Stack(
              children: [
                Image.asset(
                  titles.values.toList()[index][1],
                  scale: 1,
                  height: MediaQuery.of(context).size.height/2,
                  fit: BoxFit.fitHeight,
                  ),
                ListTile(
                  title: Center(
                    child: Text(
                      titles.keys.toList()[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                      )
                    ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: ((context) => titles.values.toList()[index][0]))
                      );
                  },
                ),
              ],
            ),
          );
        })
        ),

    );
  }
}