import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hackfest24/poseinfopage.dart';

class YogaPage extends StatefulWidget {
  YogaPage({super.key});

  @override
  State<YogaPage> createState() => _YogaPageState();
}

class _YogaPageState extends State<YogaPage> {
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
  Widget build(BuildContext context) {
    List<String> allposes =["Adho Mukha Svanasana" ,
    "Anjaneyasana",
    "Balasana",
    "Bitilasana",
    "Garudasana",
    "Malasana",
    "Padmasana",
    "Phalakasana",
    "Salamba Bhujangasana",
    "Sivasana",
    "Trikonasana",
    "Urdhva Dhanurasana",
    "Ustrasana",
      "Uttanasana",];

    return Scaffold(
        backgroundColor: Colors.black87,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black87,
              expandedHeight: 250,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset("img/yogaPg2.jpg", width: MediaQuery.of(context).size.width,height: 250, fit: BoxFit.cover,),
                // Image.network(
                //   "img/yogaPg2.jpg",
                //   fit: BoxFit.cover,
                // ),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(child: Text("Select a yoga pose", style: TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold,),), alignment: Alignment.bottomLeft,),
                  ],
                ),
                centerTitle: true,
              ),

            ),
            SliverFillRemaining(
              child: Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: allposes.length,
                              itemBuilder: (context, index){
                                return Card(
                                  color: Color(0x54c9f6cc),
                                  margin: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(allposes[index], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                    onTap: () {
                                      print("${allposes[index]} tapped");
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PoseInfoPage(pose: allposes[index])),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
              ),
                        )
          ],
        ),
    );
  }
}
