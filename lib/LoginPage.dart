import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hackfest24/signuppage.dart';

import 'authcontroller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool securetext=true;
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
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
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(
            //           "img/loginimg.png"
            //       ),
            //       fit: BoxFit.fitWidth,
            //       filterQuality: FilterQuality.high,
            //     )
            // ),
          ),
          Container(
            width:w,
            margin: const EdgeInsets.only(left: 20,right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello",
                  style:TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign into your account",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                  ),
                ),
                SizedBox(height: 50,),
                Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black

                      // boxShadow: [
                      //   BoxShadow(
                      //     blurRadius: 10,
                      //     spreadRadius: 5,
                      //     offset: Offset(1,1),
                      //     color: Colors.grey.withOpacity(0.7)
                      //   )
                      // ]
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
                      // boxShadow: [
                      //   BoxShadow(
                      //       blurRadius: 10,
                      //       spreadRadius: 5,
                      //       offset: Offset(1,1),
                      //       color: Colors.grey.withOpacity(0.7)
                      //   )
                      // ]
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
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Text(
                      "Forgot your password?",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white70
                      ),
                    ),
                  ],
                )
              ],
            ),

          ),
          SizedBox(height: 50,),
          GestureDetector(
            onTap: (){
              AuthController.instance.login(context,emailController.text.trim(), passwordController.text.trim());
            },
            child:Container(
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
                  )
                // borderRadius: BorderRadius.circular(30),
                // image: DecorationImage(
                //   image: AssetImage(
                //       "img/loginbtn.png"
                //   ),
                //   fit: BoxFit.cover,
                //   filterQuality: FilterQuality.high,
                // ),
              ),
              child: Center(
                child: Text("Sign in",
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
          RichText(
              text: TextSpan(
                  text: "Don't have an account?  ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white
                  ),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpPage()),
                          );
                        },
                      text: "Create.",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5AEA5C)
                      ),
                    )
                  ]
              )
          )
        ],
      ),
    );
  }
}