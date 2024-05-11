
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hackfest24/gympage.dart';
import 'package:hackfest24/profilepage.dart';
import 'package:hackfest24/yogapage.dart';
class HomePage extends StatefulWidget {
  String? id;
  HomePage(String? this.id, {super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _page=0;
  final screens=[
    GymPage(),
    YogaPage(),
    ProfilePage(),
  ];

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
        body:screens[_page],
    bottomNavigationBar:Container(
      color: Colors.lightGreenAccent,
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal:2, vertical:5),
        child: GNav(
          gap: 10,
          backgroundColor: Colors.lightGreenAccent,
          color: Colors.black,
          activeColor: Colors.lightGreenAccent,
          tabBackgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 17),
          // padding: EdgeInsets.all(8.0),
          onTabChange: (index){
            setState(() {
              _page = index;
          });
      },
      tabs: const [
        GButton(
          icon: Icons.fitness_center,
          text: "Gym",),
        GButton(
          icon: Icons.sports_gymnastics,
          text: "Yoga",),
        GButton(
          icon: Icons.person,
          text: "Profile",),
        ],
      ),
    )
    )
    );
  }
}