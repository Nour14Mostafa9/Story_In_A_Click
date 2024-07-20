import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first/Display.dart';
import 'package:first/Navigation.dart';
import 'package:first/SqfLiteHelper/Sqflite.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:first/DisplayScene.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common/sqlite_api.dart';

class Creation extends StatefulWidget {

  bool firstScene;
  String storyName;
  bool isAuthor ;
  Creation({super.key,required this.userName,required this.isAuthor,required this.firstScene,required this.storyName});

  String userName;

  @override
  State<Creation> createState() => _CreationState();
}

class _CreationState extends State<Creation> {


  final scene=TextEditingController();
  final sname=TextEditingController();
  final description=TextEditingController();
  var formkey = GlobalKey<FormState>();
  bool _hasError = false;
  var selectedTime ;

  List<String> characters=[];

  List<dynamic> detected_place = [];
  String place = "";
  List<dynamic> detected_characters = [];
  Map<String,String> character_dialogue ={};
  Sqflite sqfLite = Sqflite();





  Future<void> _predictEmotion(String text) async {
    try {
      Response response = await Dio().post(
        'http://10.0.2.2:8000/predict-emotion/',
        data: {'text': text},
      );
      Map<String, dynamic> data = response.data;

      setState(() {
        place = data['detected_places_and_time'] ?? " ";
        detected_characters = data['detected_characters'] ?? [];
        character_dialogue = Map<String, String>.from(data['character_dialogue'] ?? {});
        //place = detected_place.map((e) => e.toString()).join(', ');

        print(place);
        //print(place);
        print(character_dialogue);
      });
      if (place == ""){
        print("N");
        print(place);
        place = (await sqfLite.getPlaceByStoryNameLastScene(widget.storyName))!;
        print(place);
      }
    } catch (e) {
      print('Error predicting emotion: $e');
    }
  }

  String extractFirstSentence(String input) {
    int endIndex = input.indexOf(".)");

    if (endIndex != -1) {
      return input.substring(0, endIndex + 2);
    }

    return input;
  }
  late SharedPreferences StoryName ;




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: !widget.firstScene? SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Form(

            key:formkey ,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap:(){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_)=> Navigation(userName:widget.userName,isAuthor: widget.isAuthor , firstScene: true,create: false,)));
                      },
                      child:const CircleAvatar(
                        backgroundColor: Color(0xffB04BA2) ,
                        child: Center(child: Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 20,)),
                      ),

                    ),
                    SizedBox(
                      height: 120,
                    ),
                    const Center(
                      child: Text("Create Scene",style: TextStyle(color:Color(0xffFFDB5C),fontSize: 40,fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(
                        height: 100
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .8,
                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:  TextFormField(
                          style:const TextStyle(color: Color(0xffB04BA2)),
                          validator: (value){
                            if(value== null || value.isEmpty){
                              return"Please Enter Scene";
                            }
                            return null;
                          },
                          controller: scene,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration:  InputDecoration(
                            hintStyle: const TextStyle(height: 2 ),
                            hintText: "Once upon a time, there was a big forest. Rabbit: \"Good Morning everyone\"",
                            labelText: "Scene",
                            labelStyle: const TextStyle(color:  Color(0xffB04BA2),fontSize: 22),
                            hintMaxLines: 3,
                            focusedBorder: OutlineInputBorder(
                                borderSide:const BorderSide(color: Color(0xffB04BA2),width: 2),
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),

                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                        height: 50
                    ),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 60,
                        child: ElevatedButton(
                            style:ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor:  const Color(0xffB04BA2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            onPressed: ()async{

                              if(formkey.currentState!.validate()){
                                for(var sentence in character_dialogue.keys) {
                                  characters.add(sentence);
                                }

                               await _predictEmotion(scene.text);
                                print(widget.storyName);
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_)=> DisplayScene(
                                      place:  place,
                                      dialogue: character_dialogue,
                                      sceneScript: extractFirstSentence(scene.text),
                                      StoryName: widget.storyName,
                                      userName: widget.userName,
                                    )));
                              }else{
                                setState(() {
                                  _hasError = true;
                                });

                              }


                            },
                            child: const Text("Create Scene ", style: TextStyle(color: Colors.white, fontSize: 20),)),
                      ),
                    ), const SizedBox(
                        height: 50
                    ),

                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 60,
                        child: ElevatedButton(
                            style:ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor:  const Color(0xffB04BA2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            onPressed: ()async{
                              AwesomeDialog(
                                context: context,
                                keyboardAware: false,
                                dismissOnBackKeyPress: false,
                                dialogType: DialogType.question,
                                animType: AnimType.bottomSlide,
                                btnOkText: "Publish",
                                btnCancelText: "Cancel",
                                btnCancelColor:  const Color(0xffFFDB5C),
                                title: 'Finish Story',
                                desc:
                                'Do you want to save the whole story',
                                btnOkOnPress: (){
                                  print(widget.storyName);
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_)=> Display(storyName:widget.storyName,isAuthor: true,userName: widget.userName,)));

                                },
                                btnCancelOnPress: () {

                                },

                              ).show();
                              }
                            ,
                            child: const Text("Finish", style: TextStyle(color: Colors.white, fontSize: 20),)),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ):SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Form(
            key:formkey ,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text("Story Details",style: TextStyle(color:Color(0xffFFDB5C),fontSize: 40,fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(
                        height: 100
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),

                        ),
                        child:  TextFormField(
                          validator: (value){
                            if(value== null || value.isEmpty){
                              return"Please Enter Your Story Name";
                            }

                            return null;
                          },
                          controller: sname,
                          keyboardType: TextInputType.name,
                          decoration:  InputDecoration(
                            labelText: "Story Name",
                            labelStyle: const TextStyle(color:  Color(0xffB04BA2),fontSize: 17),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xffB04BA2), width: 2),
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),

                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            width:  MediaQuery.of(context).size.width * .75,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),

                            ),
                            child:  TextFormField(
                              validator: (value){
                                if(value== null || value.isEmpty){
                                  return"Please Enter Description";
                                }
                                return null;
                              },
                              controller: description,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration:  InputDecoration(
                                labelStyle: const TextStyle(color:  Color(0xffB04BA2),fontSize: 17),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xffB04BA2), width: 2),
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                                labelText: 'Description ',

                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(
                        height: 70
                    ),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 60,
                        child: ElevatedButton(
                            style:ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor:  const Color(0xffB04BA2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),

                              ),
                            ),
                            onPressed: () async{

                              if(formkey.currentState!.validate()) {
                                StoryName = await SharedPreferences.getInstance();
                                StoryName.setString('StoryName',sname.text);
                                for(var sentence in character_dialogue.keys ) {
                                  print(sentence);
                                  characters.add(sentence);
                                }
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_)=> Creation(userName:widget.userName,isAuthor: widget.isAuthor , firstScene: false,storyName: sname.text,)));
                              }else{


                              }

                            },
                            child: const Text("Start ", style: TextStyle(color: Colors.white, fontSize: 20),)),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    );
  }
}
