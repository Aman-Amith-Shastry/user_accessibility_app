import 'package:flutter/material.dart';
import 'package:user_accessibility_app/nav_bar.dart';

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

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Navigator app"),
        backgroundColor: Colors.purple,
      ),

      drawer: showNavBar(context),

      body: Container(),

    );
  }
}