import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

void main() async{
  runApp(const MaterialApp(
    home: AppPage(),
    debugShowCheckedModeBanner: false,
  ));
}


class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {

  bool _isloading = true;
  List apps = [];

  
  Future<void> _getAllAppNames() async{
    List<Application> _apps = await DeviceApps.getInstalledApplications(onlyAppsWithLaunchIntent: true,
    includeAppIcons: true, 
    includeSystemApps: true);

    setState(() {
      apps = _apps;
      _isloading = false;
    });
  }

  @override

  Widget build(BuildContext context) {

    _getAllAppNames();

    return Scaffold(
      appBar: AppBar(
        title: Text("Applications"),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new)
          ),
          
        backgroundColor: Colors.purple,

                actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context, 
                delegate: MySearchDelegate(apps));
            },
            )
        ],
      ),

      body: _isloading? Center(
        child: CircularProgressIndicator(),
      ):
      GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
        ),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          return showApps(apps, index, context);
        })
    );
  }
}

class MySearchDelegate extends SearchDelegate{

  MySearchDelegate(this.apps);
  List apps = [];
  List<String> appNames = [];
  List appIcons = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(
      icon: Icon(Icons.clear),
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
      icon: Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    List suggestions = apps.where((element){
      final result = element.appName.toString().toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList() ;

    return  GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
          ),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return showApps(suggestions, index, context);
          });
}
}

Widget showApps(apps, index, context){
  return ListTile(
  title: Container(
    width: MediaQuery.of(context).size.width/2,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.memory(
          apps[index].icon,
          height: 0.1 * MediaQuery.of(context).size.height,
          width: 0.1 * MediaQuery.of(context).size.height,
          fit: BoxFit.fill,
        ),
        SizedBox(height: 20,),
        Text(apps[index].appName, overflow: TextOverflow.clip,)
      ],
    ),
  ),
  onTap: (){
    apps[index].openApp();
  },
);
}