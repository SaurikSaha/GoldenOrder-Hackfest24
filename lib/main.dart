import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hackfest24/LoginPage.dart';

import 'authcontroller.dart';
import 'homepage.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  Get.put(AuthController()); // Initialize AuthController
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  // CameraImage? cameraImage;
  // CameraController? cameraController;
  // String output='';

  // loadCamera(){
  //   cameraController = CameraController(cameras![0], ResolutionPreset.medium);
  //   cameraController!.initialize().then((value){
  //     if(!mounted){
  //       return;
  //     }else{
  //       setState(() {
  //         cameraController!.startImageStream((imageStream) {
  //           cameraImage = imageStream;
  //           runModel();
  //         });
  //       });
  //     }
  //   });
  // }

  checkIfLogin() async{
    auth.authStateChanges().listen((User? user){
      if(user!=null && mounted){
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  // runModel() async{
  //   if(cameraImage!=null){
  //     var predictions = await Tflite.runModelOnFrame(bytesList: cameraImage!.planes.map((plane) {
  //       return plane.bytes;
  //     }).toList(),
  //         imageHeight: cameraImage!.height,
  //         imageWidth: cameraImage!.width,
  //         imageMean: 127.5,
  //         imageStd: 127.5,
  //         rotation: 90,
  //         numResults: 2,
  //         threshold: 0.1,
  //         asynch: true);
  //
  //     predictions!.forEach((element) {
  //       setState(() {
  //         output = element['label'];
  //       });
  //     });
  //   }
  // }

  // loadModel() async{
  //   await Tflite.loadModel(model: "assets/yoga_model.tflite");
  // }

  @override
  void initState(){
    checkIfLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // home: LoginPage()
      home: isLogin ? HomePage(auth.currentUser!.email) : LoginPage(), // Use AuthWrapper as the home widget
    );
  }
}

// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AuthController>(
//       init: AuthController(),
//       builder: (authController) {
//         User? user = authController.user.value;
//         return user != null ? HomePage(user.email.toString()) : LoginPage();
//       },
//     );
//   }
// }

