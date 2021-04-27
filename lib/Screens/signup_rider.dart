import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/Widgets/progress_custom.dart';
import 'package:rider_app/main.dart';
import 'package:rider_app/Screens/rider_login.dart';
class SignupScreens extends StatelessWidget {

TextEditingController nameController=TextEditingController();
TextEditingController emailController=TextEditingController();

TextEditingController phoneController=TextEditingController();
TextEditingController passController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SignUp As User",style: TextStyle(fontSize: 30.0),),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Center(child: Image.asset('assets/images/logo.png',height: 380.0,width: 380.0,)),

            Padding(
              padding: EdgeInsets.only(left: 20.0,right: 20.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(


                    hintText: 'Enter Your Name',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    suffixIcon: Icon(Icons.account_circle,color: Colors.yellow,),
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
                controller: phoneController,
                decoration: InputDecoration(

                    hintText: 'Enter Your Phone',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    suffixIcon: Icon(Icons.phone,color: Colors.yellow,),
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
                child: Text('SignUp',style: TextStyle(fontSize: 30.0,color: Colors.white,letterSpacing: 3.0,fontWeight: FontWeight.bold),),
                color: Colors.yellow,
                onPressed: (){
                  if(nameController.text.length<4){
                    Fluttertoast.showToast(msg: "name must me greater than 4 char",backgroundColor: Colors.blue);
                  }if(!emailController.text.contains(("@"))){
                    Fluttertoast.showToast(msg: "E-mail must be correct",backgroundColor: Colors.blue);
                  }if(phoneController.text.isEmpty){
                    Fluttertoast.showToast(msg: "Phone number must be written",backgroundColor: Colors.blue);

                  }if(passController.text.length<6){
                    Fluttertoast.showToast(msg: "PAssword mmust be 6 character long",backgroundColor: Colors.blue);

                  }
                  else{

                   registerUser(context);
                    nameController.clear();
                    passController.clear();
                    phoneController.clear();
                    emailController.clear();
                    Fluttertoast.showToast(msg: "Successfully Created");
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreens()));

                  }




                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
void registerUser(BuildContext context)async{
  showDialog(
      context: context,
      builder: (BuildContext context){
        return ProgressBar(message: "Creating User...",);
      }
  );
  var name=nameController.text.trim();
  var email=emailController.text.trim();
var phone=phoneController.text.trim();
final User us=(await  _firebaseAuth.createUserWithEmailAndPassword(email: emailController.text, password: passController.text).catchError((errMsg){
  print(errMsg.toString());
})).user;
print(us);
if(us!=null){
  print("if");
  print(nameController.text);
  Map userData={
    "name":name,
    "email":email,
    "phone":phone,
  };
  final uid = us.uid;
  databaseReference.child(uid).set(userData);

}



}

}
