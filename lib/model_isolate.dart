// import 'dart:async';
// import 'dart:isolate';
// // import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_v2/tflite_v2.dart';
//
// class ModelIsolate {
//   static Future<dynamic> start(List<dynamic> args) async {
//     final interpreter = await Interpreter.fromAsset('assets/yoga_model.tflite');
//     final input = args[0] as List<int>;
//     final imageHeight = args[1] as int;
//     final imageWidth = args[2] as int;
//
//     final output = List.generate(7, (index) => 0.0);
//     interpreter.run(input, output);
//
//     return {'output': output};
//   }
// }