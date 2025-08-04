import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hackfest24/authcontroller.dart';

import 'homepage.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool securetext=true;
  List images=["img/g.png","img/t.png","img/f.png"];
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var nameController=TextEditingController();
  File? file;
  ImagePicker image = ImagePicker();
  String? profUrl;
  var url;
  DatabaseReference? dbRef;

  @override
  void initState(){
    profUrl='';
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    double h=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            width: w,
            height: h*0.3,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff51f05c), Color(0xff000000)],
                  stops: [0.1, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
            ),
            child: Column(
              children: [
                SizedBox(height: h*0.16,),
                GestureDetector(
                  onTap: () {
                    // Add your onTap action here
                    getImage();
                  },
                child:CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white70,
                  backgroundImage: file != null ? FileImage(file!) as ImageProvider : AssetImage("img/profile1.png"),
                )
                )
              ],
            ),
          ),
          Container(
            width:w,
            margin: const EdgeInsets.only(left: 20,right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Container(
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(1,1),
                              color: Colors.grey.withOpacity(0.7)
                          )
                        ]
                    ),
                    child:TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                            color: Colors.white70
                        ),
                        prefixIcon: Icon(Icons.person,color: Color(0xff51f05c),),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color(0xff51f05c),
                                width: 1.0
                            )
                        ),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(30)
                        // )
                      ),
                    )
                ),
                SizedBox(height: 20,),
                Container(
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(1,1),
                              color: Colors.grey.withOpacity(0.7)
                          )
                        ]
                    ),
                    child:TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                            color: Colors.white70
                        ),
                        prefixIcon: Icon(Icons.email,color: Color(0xff51f05c),),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color(0xff51f05c),
                                width: 1.0
                            )
                        ),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(30)
                        // )
                      ),
                    )
                ),
                SizedBox(height: 20,),
                Container(
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(1,1),
                              color: Colors.grey.withOpacity(0.7)
                          )
                        ]
                    ),
                    child:TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                            color: Colors.white70
                        ),
                        suffixIcon:IconButton(
                          icon:Icon(Icons.remove_red_eye,color: Colors.grey),
                          onPressed:() {
                            setState(() {
                              securetext = !securetext;
                            });
                          },
                        ),
                        prefixIcon: Icon(Icons.password,color: Color(0xff51f05c),),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Color(0xff51f05c),
                                width: 1.0
                            )
                        ),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(30)
                        // )
                      ),
                      obscureText: securetext,
                    )
                ),
                SizedBox(height: 50,),
                GestureDetector(
                  onTap: (){
                    if (file != null) {
                      AuthController.instance.register(context,nameController.text.trim(),emailController.text.trim(), passwordController.text.trim());
                      uploadFile();
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("No image selected"),
                            backgroundColor: Color(0xff51f05c),
                            duration: Duration(seconds: 3),)
                      );
                    }
                  },
                  child: Container(
                    width: w*0.45,
                    height: h*0.075,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
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
                      child: Text("Sign up",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 70,),
                // RichText(text: TextSpan(
                //     text: "Sign up using the following.",
                //     style: TextStyle(
                //         fontSize: 20,
                //         fontWeight: FontWeight.normal,
                //         color: Colors.white70
                //     ),
                // )),
                // SizedBox(height: 20,),
                // Wrap(
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.all(10.0),
                //       child: GestureDetector(
                //         onTap: () {
                //           // Handle the onTap event for the first CircleAvatar here
                //           // For example, you can navigate to a new page or show a dialog.
                //           AuthController.instance.signInWithGoogle(context);
                //         },
                //         child: CircleAvatar(
                //           radius: 30,
                //           backgroundColor: Colors.grey,
                //           child: CircleAvatar(
                //             radius: 25,
                //             backgroundImage: AssetImage(images[0]), // Assuming images[0] is the image for the first element
                //           ),
                //         ),
                //       ),
                //     ),
                //     // Now generate the rest of the CircleAvatars starting from index 1
                //     ...List<Widget>.generate(2, (index) {
                //       return Padding(
                //         padding: EdgeInsets.all(10.0),
                //         child: CircleAvatar(
                //           radius: 30,
                //           backgroundColor: Colors.grey,
                //           child: CircleAvatar(
                //             radius: 25,
                //             backgroundImage: AssetImage(images[index + 1]), // Start from index 1
                //           ),
                //         ),
                //       );
                //     }),
                //   ],
                // )
              ],
            ),

          ),
        ],
      ),
    );
  }

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });

    // print(file);
  }

  uploadFile() async {
    try {
      var imagefile = FirebaseStorage.instance
          .ref()
          .child("Profile pictures")
          .child(await FirebaseAuth.instance.currentUser!.uid);
      UploadTask task = imagefile.putFile(file!);
      TaskSnapshot snapshot = await task;
      url = await snapshot.ref.getDownloadURL();

      setState(() {
        profUrl = url;
      });
      if (profUrl != null) {
        Map<String, String?> details = {
          'Name': nameController.text.trim(),
          'Email': emailController.text.trim(),
          'URL': profUrl,
          'Id': FirebaseAuth.instance.currentUser!.uid.toString(),
          'curls':'0',
          'pushups':'0',
          'pullups':'0',
          'squats':'0',
          'situps':'0',
          'jumpingjacks':'0'
        };
        dbRef=FirebaseDatabase.instance.ref();
        // dbRef?.child("${FirebaseAuth.instance.currentUser?.uid}").set(details);
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text("${FirebaseAuth.instance.currentUser?.uid}"),
        //       backgroundColor: Color(0xff51f05c),
        //       duration: Duration(seconds: 3),)
        // );
        // Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage(FirebaseAuth.instance.currentUser!.uid.toString())),
        // );
        // dbRef!.child("Users").child("${FirebaseAuth.instance.currentUser?.uid}").push().set(details).whenComplete(() {
        //   Navigator.pop(context);
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => HomePage(FirebaseAuth.instance.currentUser!.uid.toString())),
        //   );
        // });
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}


