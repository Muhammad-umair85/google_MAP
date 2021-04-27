import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            child: DrawerHeader(
              child: Row(
                children: [
                  Icon(Icons.supervised_user_circle,size: 50.0,),
                  SizedBox(width: 10.0,),
                  Text("Your Name",style: TextStyle(fontSize: 18.0),),
                ],
              ),

            ),

          ),
          Divider(color: Colors.black,),
          ListTile(
            title: Text("Your Profile",style: TextStyle(fontSize: 18.0),),
            leading: Icon(Icons.person_rounded,size: 30.0,),
          ),
          ListTile(
            title: Text("Ratings",style: TextStyle(fontSize: 18.0),),
            leading: Icon(Icons.rate_review_outlined,size: 30.0,),
          ),
          ListTile(
            title: Text("About",style: TextStyle(fontSize: 18.0),),
            leading: Icon(Icons.info,size: 30.0,),
          ),
        ],
      ),
    );
  }
}
