import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

void main(){
  runApp(const MaterialApp(
    home: ContactsPage(),
    debugShowCheckedModeBanner: false,
  ));
}


class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  bool disable = false;
  List<Contact> contactsList = [];
  bool _isloading = true;

  Future<void> getContact() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);

      setState(() {
        contactsList = contacts;
        _isloading = false;
      });

    }

  }

  @override
  void initState(){
    getContact();
    super.initState();
  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),

        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new)
          ),

        backgroundColor: Colors.purple,

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: (){
              showSearch(
                context: context, 
                delegate: MySearchDelegate(contactsList));
            },
            )
        ],
      ),

      body: _isloading? const Center(
        child: CircularProgressIndicator(),
      ):
        ListView.builder(
          itemCount: contactsList.length,
          itemBuilder: (context, index){
            return searchContacts(index, contactsList, context);
          }
          )

    );
  }
}

class MySearchDelegate extends SearchDelegate{
  MySearchDelegate(this.contactsList);

  List<Contact> contactsList = [];

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

    List<Contact> suggestions = contactsList.where((element){
      final result = element.name.first.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList() ;

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: ((context, index) {
        return searchContacts(index, suggestions, context);
      })
      );
  }
}

Widget searchContacts(index, List<Contact> contactsList, context){

  bool disable = false;

  final snackBar = SnackBar(
    content: const Text('Cannot open this number on WhatsApp as there is no country code'),
    action: SnackBarAction(
      label: 'CLOSE',
      onPressed: (){}),
  );

  _makingPhoneCall(String number) async {
    var url = Uri.parse(number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  return Column(
    children: [
      ExpansionTile(
        leading: (contactsList[index].photo == null)
                  ? const CircleAvatar(child: Icon(Icons.person))
                  : CircleAvatar(backgroundImage: MemoryImage(contactsList[index].photo!)),

        title: Text(contactsList[index].name.first + " " + contactsList[index].name.last),
        
        subtitle: (contactsList[index].phones.isEmpty)
        ? const Text("")
        : Text(contactsList[index].phones.first.number),

        children: [
          Row(children: [
            Expanded(
              child: IconButton(
                // disabledColor: Colors.grey.shade100,

                onPressed: () async{
                      final link = WhatsAppUnilink(
                        phoneNumber: contactsList[index].phones.first.number,
                      ).toString();

                      try{
                          if(contactsList[index].phones.first.number.startsWith("+") == false){
                            disable = true;
                          }
                        if(!disable){
                          await launch(link);
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }catch(e){
                        print("No number");
                      }
        
                  },
                icon: Icon(
                  Icons.whatsapp_outlined,
                  color: disable? Colors.grey
                    :Colors.green,
                  )),
            ),
            
            Expanded(
              child: IconButton(
                onPressed: (){
                  _makingPhoneCall("tel:"+contactsList[index].phones.first.number);
                },
                icon: const Icon(Icons.call))
              )
            
          ],)
        ],

      ),
      const Divider(height: 10,),
    ]);

}