import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DailyGoalPage extends StatefulWidget {
  const DailyGoalPage({super.key});

  @override
  State<DailyGoalPage> createState() => _DailyGoalPageState();
}

class _DailyGoalPageState extends State<DailyGoalPage> {
  var curlsController=TextEditingController();
  var squatsController=TextEditingController();
  var pushupsController=TextEditingController();
  var pullupsController=TextEditingController();
  var situpsController=TextEditingController();
  var jumpingJacksController=TextEditingController();
  DatabaseReference? dbRef;

  Future<void> getVal() async{
    print("init");
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Users").child(userId.toString()).get();
    if (snapshot.exists) {
      for(DataSnapshot snap in snapshot.children){
        setState(() {
          curlsController.text = snap.child('curls').value.toString();
          squatsController.text = snap.child('squats').value.toString();
          pushupsController.text = snap.child('pushups').value.toString();
          pullupsController.text = snap.child('pullups').value.toString();
          situpsController.text = snap.child('situps').value.toString();
          jumpingJacksController.text = snap.child('jumpingjacks').value.toString();

          if(curlsController.text == '-1'){curlsController.text = '0';}
          if(squatsController.text == '-1'){squatsController.text = '0';}
          if(pushupsController.text == '-1'){pushupsController.text = '0';}
          if(pullupsController.text == '-1'){pullupsController.text = '0';}
          if(situpsController.text == '-1'){situpsController.text = '0';}
          if(jumpingJacksController.text == '-1'){jumpingJacksController.text = '0';}

        });
      }

      print("curls: " + curlsController.text);
      print("squats " + squatsController.text);
      print("pushups " + pushupsController.text);
    }else {
      print('No data available.');
    }
  }

  @override
  void initState(){
    super.initState();
    getVal();
  }

  void setGoals() async{
    final postData = {
      'Name':'',
      'Email':'',
      'URL':'',
      'Id':'',
      'curls':curlsController.text,
      'pushups':pushupsController.text,
      'pullups':pullupsController.text,
      'squats':squatsController.text,
      'situps':situpsController.text,
      'jumpingjacks':jumpingJacksController.text
    };

    dbRef = FirebaseDatabase.instance.ref();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await dbRef?.child('Users').child(userId.toString()).get();
    if (snapshot!.exists) {
      for(DataSnapshot snap in snapshot.children){
        postData['Name']=snap.child('Name').value.toString();
        postData['Id']=snap.child('Id').value.toString();
        postData['URL']=snap.child('URL').value.toString();
        postData['Email']=snap.child('Email').value.toString();
      }
    }else {
      print('No data available.');
    }
    dbRef!.child("Users").child("${FirebaseAuth.instance.currentUser?.uid}").remove();
    dbRef!.child("Users").child("${FirebaseAuth.instance.currentUser?.uid}").push().set(postData);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Updated goals successfully", style: TextStyle(color: Colors.black),),
          backgroundColor: Color(0xff51f05c),
          duration: Duration(seconds: 3),)
    );

    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          // backgroundColor: Color(0xff61c768),
            backgroundColor: Colors.lightGreenAccent,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("GymBuddy", style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),)
              ],
            ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Center(child: Text("Set your daily goals!",style: TextStyle(color: Color(0xff51f05c),fontSize: 25, fontWeight: FontWeight.bold),)),
              const SizedBox(height: 20,),
              Text("Curls: ",style: TextStyle(color: Colors.lightGreenAccent,fontSize: 15,),textAlign: TextAlign.start),
              Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey
                  ),
                  child:TextField(
                    controller: curlsController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.email,color: Color(0xff51f05c),),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xff51f05c),
                              width: 3.0
                          )
                      ),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(30)
                      // )
                    ),
                  )
              ),
              const SizedBox(height: 20,),
              Text("Pushups: ",style: TextStyle(color: Colors.lightGreenAccent,fontSize: 15,),textAlign: TextAlign.start ),
              Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey
                  ),
                  child:TextField(
                    controller: pushupsController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.email,color: Color(0xff51f05c),),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xff51f05c),
                              width: 3.0
                          )
                      ),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(30)
                      // )
                    ),
                  )
              ),
              const SizedBox(height: 20,),
              Text("Pullups: ",style: TextStyle(color: Colors.lightGreenAccent,fontSize: 15,),textAlign: TextAlign.start ),
              Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey
                  ),
                  child:TextField(
                    controller: pullupsController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.email,color: Color(0xff51f05c),),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xff51f05c),
                              width: 3.0
                          )
                      ),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(30)
                      // )
                    ),
                  )
              ),
              const SizedBox(height: 20,),
              Text("Squats: ",style: TextStyle(color: Colors.lightGreenAccent,fontSize: 15),textAlign: TextAlign.start ),
              Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey
                  ),
                  child:TextField(
                    controller: squatsController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.email,color: Color(0xff51f05c),),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xff51f05c),
                              width: 3.0
                          )
                      ),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(30)
                      // )
                    ),
                  )
              ),
              const SizedBox(height: 20,),
              Text("Situps: ",style: TextStyle(color: Colors.lightGreenAccent,fontSize: 15,),textAlign: TextAlign.start ),
              Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey
                  ),
                  child:TextField(
                    controller: situpsController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.email,color: Color(0xff51f05c),),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xff51f05c),
                              width: 3.0
                          )
                      ),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(30)
                      // )
                    ),
                  )
              ),
              const SizedBox(height: 20,),
              Text("Jumping Jacks: ",style: TextStyle(color: Colors.lightGreenAccent,fontSize: 15,),textAlign: TextAlign.start ),
              Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey
                  ),
                  child:TextField(
                    controller: jumpingJacksController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      // prefixIcon: const Icon(Icons.email,color: Color(0xff51f05c),),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xff51f05c),
                              width: 3.0
                          )
                      ),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(30)
                      // )
                    ),
                  )
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  setGoals();
                },
                child: Container(
                  width: 150,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFF5AEA5C),
                        Color(0xFF67E769),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text("Set goals",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        )
    );
  }
}
