import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    fetch();

    super.initState();
  }

  Future<void> fetch() async {
    print("chk1");
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print("chk2");
    final ref = FirebaseDatabase.instance.ref();
    print("chk3");
    final snapshot = await ref.child('Users').child(userId.toString()).get();
    // final dataMap= snapshot.value as Map<String,String>;
    if (snapshot.exists) {
      print("xxxxx");
      Map<String, dynamic>? userData = snapshot.value as Map<String, dynamic>?;
      print("zzzz");
      String name = userData?['Name'];
      print("nm: "+name);
      // final dataMap = snapshot.value as Map;
      //
      // dataMap.forEach((key, value) {
      //   print("zzzz "+key+" : "+value);
      // });
    }else {
      print('No data available.');
    }
    print("chk5");

    // print("ccccc");
    // DatabaseReference dbRef = FirebaseDatabase.instance.ref('Users');
    // try{
    //   final snapshot = await dbRef.get();
    //   print("yyyy");
    //   final dataMap=snapshot as Map<String,String>;
    //   print("zzzzzzzzzz: "+dataMap['Name']!);
    // }catch(e){
    //   print("rrrrr: "+e.toString());

    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Text("Profile")
    );
  }
}
