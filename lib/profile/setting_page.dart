import 'package:flutter/material.dart';
class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272139),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20,20,20,0),
        child: Column(
          children: [
            ListTile(
            onTap: (){},
            title: Text('Notification',style: TextStyle(color: Colors.white),),
            leading: Icon(Icons.notification_add,color: Colors.white,),
          ),
            ListTile(
              onTap: (){},
              title: Text('Contact Us'),
              leading: Icon(Icons.quick_contacts_mail),
              textColor: Colors.white,
              iconColor: Colors.white,
            ),
            ListTile(
              onTap: (){},
              title: Text('Terms & Codition'),
              leading: Icon(Icons.question_mark),
              textColor: Colors.white,
              iconColor: Colors.white,
            ),
            ListTile(
              onTap: (){},
              title: Text('Policy'),
              leading: Icon(Icons.policy),
              textColor: Colors.white,
              iconColor: Colors.white,
            ),
            ListTile(
              onTap: (){},
              title: Text('Logout'),
              leading: Icon(Icons.logout),
              textColor: Colors.white,
              iconColor: Colors.white,
            ),


          ],
        ),
      ),
    );
  }
}
