import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackfest24/main.dart';
// import 'package:tflite/tflite.dart';
import 'package:tflite_v2/tflite_v2.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

class YogaCam extends StatefulWidget {
  YogaCam({super.key});

  @override
  State<YogaCam> createState() => _YogaCamState();
}

class _YogaCamState extends State<YogaCam> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output='';

  @override
  void initState(){
    super.initState();
    loadCamera();
    loadModel();
  }

  bool isModelRunning = false;

  void loadCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            debugPrint("camera is ON.");
            if (!isModelRunning) {
              isModelRunning = true;
              cameraImage = imageStream;
              runModel().then((_) {
                isModelRunning = false;
              });
            } else {
              // Model is already running, process frame without inference
              cameraImage = imageStream;
              // Update UI if necessary
            }
          });
        });
      }
    });
  }


  // loadCamera(){
  //   cameraController = CameraController(cameras![0], ResolutionPreset.medium);
  //   cameraController!.initialize().then((value){
  //     if(!mounted){
  //       return;
  //     }else{
  //       setState(() {
  //         cameraController!.startImageStream((imageStream) {
  //           debugPrint("camera is ON.");
  //           cameraImage = imageStream;
  //           runModel();
  //         });
  //       });
  //     }
  //   });
  // }

  Future<String?> runModel() async {
    // Run your TensorFlow Lite model inference
    try{
      var input = _convertCameraImageToUint8List(cameraImage!);
      var predictions = await Tflite.runModelOnFrame(
        bytesList: [input],
        imageHeight: 210,
        imageWidth: 200,
      );
      print("output "+predictions?[0]['label']);
      if (predictions != null && predictions.isNotEmpty) {
        return predictions[0]['label']; // Assuming the label is a string
      } else {
        return 'null'; // Return an empty string if no predictions are available
      }
    }catch(e){
      print("run model failed $e");
    }
    return null;
  }

  loadModel() async{
    try{
      await Tflite.loadModel(model: "assets/yoga_model.tflite");
    }catch(e){
      print("load model failed $e");
    }
  }

  // void _processCameraImage(CameraImage image) async {
  //   // Convert CameraImage to Uint8List
  //   var input = _convertCameraImageToUint8List(image);
  //
  //   // Preprocess image data as needed for your model
  //
  //   // Run inference
  //   var output = await Tflite.runModelOnFrame(
  //     bytesList: [input],
  //   );

  // Process the output of the inference

  // Reset detecting flag
  // _isDetecting = false;
  // }

  Uint8List _convertCameraImageToUint8List(CameraImage image) {
    // Convert CameraImage to Uint8List
    var byteBuffer = image.planes[0].bytes;
    var pixels = Uint8List.view(byteBuffer.buffer);
    return pixels;
  }

  @override
  Widget build(BuildContext context) {
    return
      PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) async {
          cameraController?.dispose();
          Navigator.pop(context);
          debugPrint("did pop $didPop");
        },
        child:
        Scaffold(
          backgroundColor: Colors.black87,
          body: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.64,
                width: MediaQuery.of(context).size.width,
                child: !cameraController!.value.isInitialized?
                Container():
                AspectRatio(aspectRatio: cameraController!.value.aspectRatio,
                  child: CameraPreview(cameraController!),),

              ),
              Text(output, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, backgroundColor: CupertinoColors.systemGreen ,color: Colors.white),)
            ],
          ),

        ),
      );
  }
}

// class _YogaCamState extends State<YogaCam> {
//   CameraImage? cameraImage;
//   CameraController? cameraController;
//   String output='';
//   Interpreter? interpreter;
//
//   @override
//   void initState() {
//     super.initState();
//     _initCameraAndModel();
//   }
//
//   Future<void> _initCameraAndModel() async {
//     await _loadModel();
//     await _loadCamera();
//   }
//
//   Future<void> _loadModel() async {
//     try {
//       interpreter = await Interpreter.fromAsset('assets/yoga_model.tflite');
//     } catch (e) {
//       print("Error loading model: $e");
//     }
//     // try {
//     //   await Tflite.loadModel(model: "assets/yoga_model.tflite");
//     // } catch (e) {
//     //   print("Error loading model: $e");
//     // }
//   }
//
//   Future<void> _loadCamera() async {
//     if (cameras == null || cameras!.isEmpty) {
//       print("No cameras available");
//       return;
//     }
//
//     final camera = cameras![0];
//     cameraController = CameraController(camera, ResolutionPreset.medium);
//     try {
//       await cameraController!.initialize();
//       if (!mounted) return;
//
//       setState(() {
//         cameraController!.startImageStream(_processImageStream);
//       });
//     } catch (e) {
//       print("Error initializing camera: $e");
//     }
//   }
//
//   void _processImageStream(CameraImage image) {
//     debugPrint("Camera is ON.");
//     final imageData = _convertCameraImageToUint8List(image);
//     _runModel(imageData);
//   }
//
//   // final _modelRunQueue = <Uint8List>[];
//
//   Future<void> _runModel(Uint8List imageData) async {
//     // _modelRunQueue.add(imageData);
//     // _processQueue();
//
//     final inputShape = interpreter!.getInputTensor(0).shape;
//     final inputImage = _convertImageToTensorImage(imageData, inputShape[1], inputShape[2]);
//     interpreter!.allocateTensors();
//     final outputs = <List<double>>[];
//     interpreter!.run(inputImage.buffer, outputs);
//
//     var output = outputs[0];
//     final predictedClass = labels[output.indexOf(output.reduce(max))];
//
//     setState(() {
//       output = 'Predicted Class: $predictedClass';
//     });
//   }
//
//   TensorImage _convertImageToTensorImage(Uint8List imageData, int inputWidth, int inputHeight) {
//     final tensorImage = TensorImage(interpreter!.getInputTensor(0).dataType);
//     tensorImage.loadImage(imageData);
//     final resizedImage = tensorImage.resize([inputHeight, inputWidth]);
//     return resizedImage;
//   }
//
//   // Future<void> _processQueue() async {
//   //   if (_modelRunQueue.isEmpty) return;
//   //
//   //   final imageData = _modelRunQueue.removeAt(0);
//   //   try {
//   //     final predictions = await Tflite.runModelOnFrame(
//   //       bytesList: [imageData],
//   //       imageHeight: 210,
//   //       imageWidth: 200,
//   //     );
//   //
//   //     print(predictions);
//   //   } catch (e) {
//   //     print("Error running model: $e");
//   //   } finally {
//   //     _processQueue(); // Process the next item in the queue
//   //   }
//   // }
//
//   Uint8List _convertCameraImageToUint8List(CameraImage image) {
//     // Convert CameraImage to Uint8List
//     var byteBuffer = image.planes[0].bytes;
//     var pixels = Uint8List.view(byteBuffer.buffer);
//     return pixels;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       PopScope(
//       canPop: true,
//       onPopInvoked: (bool didPop) async {
//         cameraController?.dispose();
//         Navigator.pop(context);
//         debugPrint("did pop $didPop");
//       },
//       child:
//       Scaffold(
//         backgroundColor: Colors.black87,
//         body: Column(
//           children: [
//               Container(
//                 height: MediaQuery.of(context).size.height*0.64,
//                 width: MediaQuery.of(context).size.width,
//                 child: !cameraController!.value.isInitialized?
//                 Container():
//                 AspectRatio(aspectRatio: cameraController!.value.aspectRatio,
//                   child: CameraPreview(cameraController!),),
//
//               ),
//             Text(output, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, backgroundColor: CupertinoColors.systemGreen ,color: Colors.white),)
//           ],
//         ),
//
//       ),
//     );
//   }
// }
