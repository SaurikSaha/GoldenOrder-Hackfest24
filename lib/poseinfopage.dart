import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackfest24/yogacam.dart';

class PoseInfoPage extends StatefulWidget {
  String pose;
  PoseInfoPage({super.key,required this.pose});

  @override
  State<PoseInfoPage> createState() => _PoseInfoPageState();
}

class _PoseInfoPageState extends State<PoseInfoPage> {
  late String pose;
  final Map<String, String> imageMap = {"Adho Mukha Svanasana": 'img/Adho-Mukha-Svanasana.jpg' ,
  "Anjaneyasana": 'img/Anjaneyasana.jpg',
  "Balasana": 'img/Balasana.jpg',
  "Bitilasana": 'img/Bitilasana.jpg',
  "Garudasana": 'img/Garudasana.jpg',
  "Malasana": 'img/Malasana.jpg',
  "Padmasana": 'img/Padmasana.jpg',
  "Phalakasana": 'img/Phalakasana.jpg',
  "Salamba Bhujangasana": 'img/Salamba-Bhujangasana.jpg',
  "Sivasana": 'img/Sivasana.jpeg',
  "Trikonasana": 'img/Trikonasana.jpg',
  "Urdhva Dhanurasana": 'img/Urdhva-Dhanurasana.png',
  "Ustrasana": 'img/Ustrasana.jpg',
  "Uttanasana": 'img/Uttanasana.jpg'};

  @override
  void initState(){
    super.initState();
    pose=widget.pose;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xff61c768),
          backgroundColor: Colors.lightGreenAccent,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.sports_gymnastics, color: Colors.black,),
              // SizedBox(width: 5,),
              Text("GymBuddy", style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),)
            ],
          )
      ),
      body:
      Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Center(
                child: Container(
                  // height: MediaQuery.of(context).size.height,
                  color: Colors.white, // Set background color to black
                  child: Center(
                    child: Image.asset(
                      imageMap[pose]!,
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ),
    SizedBox(height: 20,),
    Container(
            height: 80,
            color: Colors.white,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => YogaCam(pose: pose)),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: Text('Press Me'),
              ),
            ),
          ),
              SizedBox(height: 20,)

            ],
            // children: <Widget>[
            //   // Expanded widget to take up remaining space
            //   Center(
            //     child: Container(
            //       color: Colors.black, // Set background color to black
            //       child: Center(
            //         child: Image.asset(
            //           imageMap[pose]!,
            //           width: 300,
            //           height: 300,
            //         ),
            //       ),
            //     ),
            //   ),
            //   // Button section
            //   Container(
            //     height: MediaQuery.of(context).size.height*0.7,
            //     color: Colors.black, // Set background color to white
            //     child: Center(
            //       child: ElevatedButton(
            //         onPressed: () {
            //           Navigator.push(context, MaterialPageRoute(builder: (context) => YogaCam(pose: pose)),
            //           );
            //         },
            //         style: ButtonStyle(
            //           backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            //           foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            //         ),
            //         child: Text('Press Me'),
            //       ),
            //     ),
            //   ),
            // ],
          ),
        ),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       // Image widget displaying your image
      //       Image.asset(
      //         imageMap[pose]!, // Replace 'your_image.png' with your image asset path
      //         width: 200, // Adjust the width as needed
      //         height: 200, // Adjust the height as needed
      //       ),
      //       SizedBox(height: 20), // Add some space between the image and button
      //       // Button widget
      //       ElevatedButton(
      //         style: ButtonStyle(
      //           backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreenAccent),
      //           foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      //         ),
      //         onPressed: () {
      //           // Add your button onPressed logic here
      //           print('Button pressed');
      //         },
      //         child: Text('START CAMERA'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
