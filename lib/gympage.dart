import 'package:flutter/material.dart';

class GymPage extends StatelessWidget {
  const GymPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset("img/gympageIcon.png", width: 400,),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                width: 450,
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select to start working out",
                    style: TextStyle(
                      color: Colors.lightGreenAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                SizedBox(width: 5,),
                Expanded(
                  flex: 33,
                  child: Card(
                    // color: Color(0x33f8f8f8),
                    clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Color(0x4A000000),
                          onTap: (){
                          debugPrint("squats clicked");
                          },
                        child: SizedBox(
                            width: 300,
                              height: 150,
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  Image.asset("img/squats.png", height: 90,),
                                  SizedBox(height: 12,),
                                  Text("Squat",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      // color: Colors.white
                                    ),)
                                ]
                              )
                          ),
                      ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 33,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Color(0x4A000000),
                      onTap: (){
                        debugPrint("handstand clicked");
                      },
                      child: SizedBox(
                          width: 300,
                          height: 150,
                          child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Image.asset("img/handstand.png", height: 110,),
                                SizedBox(height: 2,),
                                Text("Handstand",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),)
                              ]
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 33,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Color(0x4A000000),
                      onTap: (){
                        debugPrint("deadlift clicked");
                      },
                      child: SizedBox(
                        width: 300,
                        height: 150,
                          child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Image.asset("img/deadlift.png", height: 85,),
                                SizedBox(height: 17,),
                                Text("Deadlift",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),)
                              ]
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                SizedBox(width: 5,),
                Expanded(
                  flex: 33,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Color(0x4A000000),
                      onTap: (){
                        debugPrint("jumping jacks clicked");
                      },
                      child: SizedBox(
                          width: 300,
                          height: 150,
                          child: Column(
                              children: [
                                SizedBox(height: 5,),
                                Image.asset("img/jumpingjacks.png", height: 110,),
                                SizedBox(height: 8,),
                                Text("Jumping Jacks",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                  ),)
                              ]
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 33,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Color(0x4A000000),
                      onTap: (){
                        debugPrint("situps clicked");
                      },
                      child: SizedBox(
                          width: 300,
                          height: 150,
                          child: Column(
                              children: [
                                SizedBox(height: 25,),
                                Image.asset("img/situps.png", height: 75,),
                                SizedBox(height: 23,),
                                Text("Situps",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),)
                              ]
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 33,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Color(0x4A000000),
                      onTap: (){
                        debugPrint("pushups clicked");
                      },
                      child: SizedBox(
                          width: 300,
                          height: 150,
                          child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Image.asset("img/pushups.png", height: 85, width: 100,),
                                SizedBox(height: 17,),
                                Text("Pushups",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),)
                              ]
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: [
                SizedBox(width: 5,),
                Expanded(
                  flex: 33,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Color(0x4A000000),
                      onTap: (){
                        debugPrint("pullups clicked");
                      },
                      child: SizedBox(
                          width: 300,
                          height: 150,
                          child: Column(
                              children: [
                                SizedBox(height: 10,),
                                Image.asset("img/pullups.png", height: 100,),
                                SizedBox(height: 12,),
                                Text("Pullups",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                  ),)
                              ]
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 33,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Color(0x4A000000),
                      onTap: (){
                        debugPrint("bench press clicked");
                      },
                      child: SizedBox(
                          width: 300,
                          height: 150,
                          child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Image.asset("img/benchpress.png", height: 90,),
                                SizedBox(height: 12,),
                                Text("Bench press",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),)
                              ]
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 33,
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: Color(0x4A000000),
                      onTap: (){
                        debugPrint("Curls clicked");
                      },
                      child: SizedBox(
                          width: 300,
                          height: 150,
                          child: Column(
                              children: [
                                SizedBox(height: 15,),
                                Image.asset("img/curls.png", height: 95,),
                                SizedBox(height: 14,),
                                Text("Curls",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),)
                              ]
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
              ],
            )
          ],
        ),
      )
    );
  }
}
