import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CamPage extends StatefulWidget {
  String exercise;
  CamPage({super.key,required this.exercise});

  @override
  State<CamPage> createState() => _CamPageState();
}

class _CamPageState extends State<CamPage> {
  late String exercise;
  late CameraController _controller;
  Timer? _timer;
  bool _isStreaming = false;
  String _processedImage = '';
  dynamic responseData;
  int reset=1;
  String target="-1";

  @override
  void initState(){
    super.initState();
    exercise=widget.exercise;
    fetch();
    initCamera();
  }

  Future<void> fetch() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('Users').child(userId.toString()).get();
    if (snapshot.exists) {
      for(DataSnapshot snap in snapshot.children){
        setState(() {
          target = snap.child('${exercise}').value.toString();
        });
      }
    }else {
      print('No data available.');
    }
  }

  void showAlert(){
    QuickAlert.show(
      context: context,
      title: exercise.toUpperCase(),
      text: "Daily goal achieved",
      type: QuickAlertType.success
    );
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _controller = CameraController(camera, ResolutionPreset.medium);
    await _controller.initialize();
    startCameraStream();
  }

  Future<void> captureAndSendFrames() async {
    print("func");
    if (!_controller.value.isInitialized) {
      return;
    }
    XFile image = await _controller.takePicture();
    Uint8List imageBytes = await image.readAsBytes();
    String apiUrl = 'http://192.168.246.6:5000/${exercise}?target=${target}&reset=${reset}';
    print('Sending image to API: $apiUrl');
    final response= await http.post(
      Uri.parse(apiUrl),
      body: json.encode({'image': base64Encode(imageBytes)}),
      headers: {'Content-Type': 'application/json'},
    );
    reset=0;
    print('status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print("exe");
      try {
        responseData = jsonDecode(response.body);
      }catch(e){
        print("exc: "+e.toString());
      }
      print("txt");
      print('response: ${responseData}');
      setState(() {
        _processedImage = responseData['processed_image'];
        print('_processedImage '+_processedImage.toString());
        int isTarget=responseData['isTarget'];
        if(isTarget==1){
          stopCameraStream();
          _controller.dispose();
          Navigator.pop(context);
          showAlert();
        }
      });
    } else {
      print('Failed to process image: ${response.statusCode}');
    }
  }

  void startCameraStream() async {
    if (!_controller.value.isInitialized) {
      return;
    }
    _isStreaming = true;
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      captureAndSendFrames();
    });
  }

  void stopCameraStream() {
    _isStreaming = false;
    _timer?.cancel();
    reset=1;
  }

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          if (_processedImage.isNotEmpty)
            Positioned.fill(
              child: Image.memory(
                base64Decode(_processedImage),
                width: w*0.3,
                height: h,// Cover the entire screen
              ),
            ),
        ],
      ),
    );
  }
}
