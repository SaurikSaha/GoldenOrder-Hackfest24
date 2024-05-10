
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'LoginPage.dart';
import 'homepage.dart';
class AuthController extends GetxController{

  static AuthController instance= Get.find();
  late Rx<User?> user=Rx<User?>(null);
  FirebaseAuth auth=FirebaseAuth.instance;

  @override
  void onReady(){
    super.onReady();
    user = auth.currentUser?.obs ?? Rx<User?>(null);
    user.bindStream(auth.userChanges());
    // ever<User?>(user, initialScreen);
  }

  initialScreen(User? user){
    if(user==null){
      print("login page");
      Get.offAll(()=> LoginPage());
    }
    else{
      print("home page");
      Get.offAll(()=> HomePage(user.email.toString()));
    }
  }

  register(BuildContext context,String email,String password) async {
    try{
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage(auth.currentUser!.email.toString())),
              (route) => false);

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage(auth.currentUser!.email.toString())),
      // );
    }catch(e){
      var s=e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.substring(s.indexOf(']'))),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),)
      );
    }
  }

  login(BuildContext context,String email,String password) async {
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(auth.currentUser!.email.toString())),
      );
    }catch(e) {
      var s = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.substring(s.indexOf(']'))),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),)
      );
    }
  }

  signInWithGoogle(BuildContext context) async{
    final GoogleSignInAccount? guser=await GoogleSignIn(scopes: <String>["email"]).signIn();
    final GoogleSignInAuthentication gAuth=await guser!.authentication;
    final credential=GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(auth.currentUser!.email.toString())),
    );
  }

  logout(BuildContext context) async {
    await auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}