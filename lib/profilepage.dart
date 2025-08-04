import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackfest24/LoginPage.dart';
import 'package:hackfest24/dailygoalpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username='';
  String useremail='';
  String imgUrl='';

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
    if (snapshot.exists) {
      print("xxxxx");
      for(DataSnapshot snap in snapshot.children){
        setState(() {
          username = snap.child('Name').value.toString();
          useremail = snap.child('Email').value.toString();
          imgUrl = snap.child('URL').value.toString();
        });
      }
      print("username: $username, useremail: $useremail");
      print("url: $imgUrl");
      // print("zzzz "+snap.child('Name').value.toString());
    }else {
      print('No data available.');
    }
    print("chk5");
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  // alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.9,
                  height: MediaQuery.of(context).size.height*0.55,
                  child: Card(
                    color: Colors.grey,
                    borderOnForeground: true,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white70,
                          backgroundImage: NetworkImage(imgUrl,),
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white60,
                            ),
                            height: 60,
                            width: 325,
                            child: Center(child: Text("Username: "+username, textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white60,
                            ),
                            height: 60,
                            width: 325,
                            child: Center(child: Text("Email: "+useremail, textAlign: TextAlign.left,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                          ),
                        ),
                        SizedBox(height: 55,),
                        GestureDetector(
                          onTap: (){
                            FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child:Container(
                            width: 125,
                            height: 65,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xFF5AEA5C),
                                    Color(0xFF67E769),
                                  ],
                                )
                            ),
                            child: const Center(
                              child: Text("Log out",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 60,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DailyGoalPage()),
                    );
                  },
                  child:Container(
                    width: 185,
                    height: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFF5AEA5C),
                            Color(0xFF67E769),
                          ],
                        )
                    ),
                    child: const Center(
                      child: Text("Set daily goals",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
