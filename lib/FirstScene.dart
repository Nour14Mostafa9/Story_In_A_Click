/*
import 'package:first/StoryCreation.dart';
import 'package:flutter/material.dart';

class FirstScene extends StatefulWidget {
  final String email;
   FirstScene({super.key, required this.email});

  @override
  State<FirstScene> createState() => _FirstSceneState();
}

class _FirstSceneState extends State<FirstScene> {
  bool home = true;


  @override
  void initState(){

    super.initState();
    navToSign();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image:AssetImage("assets/fisrtScene.png"),
                  fit: BoxFit.cover
              )
          ),
          child: const Center(
              child:Text("Creativity Time ",style: TextStyle(color:  Color(0xffFFDB5C)),)
          ),)
    );
  }

  void navToSign()async {
    await Future.delayed(const Duration(milliseconds: 5000),(){

    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>  Creation(firstScene: true,userName:widget.email ,storyName: "",)));

  }


}
*/
