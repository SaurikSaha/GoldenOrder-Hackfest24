import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class YogaCam extends StatefulWidget {
  String pose;
  YogaCam({super.key,required this.pose});

  @override
  State<YogaCam> createState() => _YogaCamState();
}

class _YogaCamState extends State<YogaCam> {
  late String pose;
  late CameraController _controller;
  Timer? _timer;
  bool _isStreaming = false;
  String _processedImage = '';
  dynamic responseData;
  int reset=1;

  @override
  void initState(){
    super.initState();
    pose=widget.pose;
    initCamera();
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
    String apiUrl = 'http://192.168.246.6:5000/yoga?pose=${pose}';
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
      if(_timer?.tick==300){
        stopCameraStream();
        Navigator.pop(context);
      }
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
