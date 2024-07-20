import 'package:first/Component/tff.dart';
import 'package:first/Navigation.dart';
import 'package:first/SqfLiteHelper/Sqflite.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressPage extends StatefulWidget {

  String email;
   ProgressPage({super.key, required this.email});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {

  final PageController _pageController = PageController();
  int currentIndex = 0;

  Sqflite db = Sqflite();

  List<String> animals=["lion.png","turtle.png","elephant.png"];
  List<double> percent=[0,0.5,1];
  List<String> texts=[
    "WHAT IS YOUR FAVORITE ANIMAL",
    "HOW OLD ARE YOU",
    "WHAT IS YOUR NICKNAME",
  ];

  List<String> details=[];
  TextEditingController info= TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      content(0),
      content(1),
      content(2),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PageView(
          controller: _pageController,
          children: pages,
        ),
        ),

    );
  }


Widget content(int Index) {
  return ListView(
      children: [
        Image.asset("assets/animal/${animals[Index]}", height: 300, width: 250,),
        const SizedBox(height: 10,),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LET'S BE", style: TextStyle(color: Colors.black, fontSize: 25),),
            Text(" FRIENDS",
              style: TextStyle(color: Color(0xffB04BA2), fontSize: 25),),

          ],
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Container(
            width: 180,
            height: 90,
            decoration: BoxDecoration(
                color: const Color(0xffB04BA2),
                borderRadius: BorderRadius.circular(35)
            ),
            child:  Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(texts[Index],
                    maxLines: 2,
                    style: const TextStyle(color: Color(0xffFFDB5C), fontSize: 20,fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20,),
        Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 8),
            child: TextFF(
              visible: false,
              backColor: const Color(0xffFFDB5C) ,
                textColor: Colors.white,
                textSize: 20,
                hint: 'Huum?',
                controller: info,
                suffix: null,
                keyboardType: TextInputType.visiblePassword,
                validation: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Your password";
                  }
                  return null;
                }
            )
        ),
        const SizedBox(height: 10,),
        TextButton(
            onPressed: () {
              if (currentIndex == 2) {
                currentIndex =0;
                details.add(info.text);
                db.updateUserInfo(email: widget.email, favoriteAnimal: details[0], age: int.parse(details[1]), nickname: details[2]);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Navigation(isAuthor: false ,userName: widget.email,create: false,firstScene: true,)));

              } else {
                details.add(info.text);
                info.text="";
                currentIndex++;
                _pageController.jumpToPage(currentIndex);
              }
            },
            child: const Text(
                "Next", style: TextStyle(color: Colors.grey, fontSize: 18))),
        const SizedBox(height: 40,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearPercentIndicator(
              width: 230.0,
              lineHeight: 15.0,
              percent: percent[Index],
              barRadius: const Radius.circular(20),
              backgroundColor: Colors.grey,
              progressColor: const Color(0xffFFDB5C),
            ),
          ],
        ),
      ]
  );
}
}