import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/Widgets/progress_custom.dart';

import '../main.dart';
import 'main_screen.dart';
class LoginScreens extends StatelessWidget {
  TextEditingController emailController=TextEditingController();
  TextEditingController passController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Rider App"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Center(child: Image.asset('assets/images/logo.png',height: 350.0,width: 350.0,)),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0,right: 20.0),
              child: TextField(
                controller: emailController,
                  decoration: InputDecoration(

                      hintText: 'Enter Your E-Mail',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      suffixIcon: Icon(Icons.email,color: Colors.yellow,),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color:Colors.black),
                      )
                  ),


              ),
            ),
            SizedBox(height: 40.0,),
            Padding(
              padding: EdgeInsets.only(left: 20.0,right: 20.0),

              child: TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    hintText: 'Password',
                    suffixIcon: Icon(Icons.visibility_off,color: Colors.yellow,),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.black),
                    )
                ),

              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            ButtonTheme(
             minWidth: 200.0,
              height: 50.0,

              child: RaisedButton(

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.red)
                ),
                child: Text('Login',style: TextStyle(fontSize: 30.0,color: Colors.white,letterSpacing: 3.0,fontWeight: FontWeight.bold),),
                color: Colors.yellow,
                onPressed: (){

                  if(!emailController.text.contains(("@"))){
                    Fluttertoast.showToast(msg: "E-mail must be correct",backgroundColor: Colors.blue);
                  }if(passController.text.isEmpty){
                    Fluttertoast.showToast(msg: "PAssword mmust be  Written",backgroundColor: Colors.blue);

                  }else{
                    signInUser(context);

                  }
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminPanel()));



                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  //AIzaSyBIOS34W57OAeQ7AyYZO3glY6hKSKXeAP8
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  void signInUser(BuildContext context)async{
showDialog(
  context: context,
  builder: (BuildContext context){
    return ProgressBar(message: "Please Wait...",);
  }
);
     final User user =(await _firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passController.text)).user;
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
Fluttertoast.showToast(msg: "SUccessfully Login");

     _firebaseAuth.currentUser;
    final uid = user.uid;
    if(user!=null){
      databaseReference.child(uid).once().then((DataSnapshot snap){
        if(snap.value!=null){

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
          Fluttertoast.showToast(msg: "Successfully LogIn");


        }else{
          print("f");
          Navigator.pop(context);
          _firebaseAuth.signOut();
          Fluttertoast.showToast(msg: "Details Not Found SignUp Again");

        }
      });

    }else{
      Fluttertoast.showToast(msg: "Please Register YourSelf");

    }



  }

}
