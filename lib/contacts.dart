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

_makingPhoneCall(String number) async {
  var url = Uri.parse(number);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchWhatsapp(String number) async{

  String fin_number = '';

  if(number.startsWith("+") == false){
    if(number.startsWith("+91") == false){
      fin_number = "+91 $number";
    }
  }

  else{
    fin_number = "+91 ${number.split('+91').last}";
  }

  final link = WhatsAppUnilink(
    phoneNumber: fin_number,
  );
  if(await canLaunch('$link')){
    await launch('$link');
  }
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
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


  Widget build(BuildContext context) {

    getContact();

    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),

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
                delegate: MySearchDelegate(contactsList));
            },
            )
        ],
      ),

      body: _isloading? Center(
        child: CircularProgressIndicator(),
      ):
        ListView.builder(
          itemCount: contactsList.length,
          itemBuilder: (context, index){
            return searchContacts(index, contactsList);
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

    List<Contact> suggestions = contactsList.where((element){
      final result = element.name.first.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList() ;

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: ((context, index) {
        return searchContacts(index, suggestions);
      })
      );
  }
}

  Widget searchContacts(index, List<Contact> contactsList){
    return Column(
      children: [
        ExpansionTile(
          leading: (contactsList[index].photo == null)
                    ? const CircleAvatar(child: Icon(Icons.person))
                    : CircleAvatar(backgroundImage: MemoryImage(contactsList[index].photo!)),

          title: Text(contactsList[index].name.first),
          
          subtitle: (contactsList[index].phones.isEmpty)
          ? Text("")
          : Text(contactsList[index].phones.first.number),

          children: [
            Row(children: [
              Expanded(
                child: IconButton(
                  onPressed: (){
                    _launchWhatsapp(contactsList[index].phones.first.number);
                  },
                  icon: Icon(Icons.whatsapp_outlined, color: Colors.green,)),
              ),
              
              Expanded(
                child: IconButton(
                  onPressed: (){
                    _makingPhoneCall("tel:"+contactsList[index].phones.first.number);
                  },
                  icon: Icon(Icons.call))
                )
              
            ],)
          ],

        ),

        Divider(height: 10,)
      ]);
  }