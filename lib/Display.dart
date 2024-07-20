import 'dart:ui';

import 'package:first/Navigation.dart';
import 'package:first/SqfLiteHelper/Sqflite.dart';
import 'package:first/StoryCreation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class Display extends StatefulWidget {
  String storyName;
  bool isAuthor ;
  String userName;

  Display({super.key, required this.storyName, required this.isAuthor, required this.userName});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {

  final FlutterTts flutterTts = FlutterTts();
  String _text = "Once upon a time, in a land far away, there lived a wise old owl.";

  Sqflite sqfLite = Sqflite();
  String? place;
  String? email;
  List<String> animal = [];
  List<String> sceneScript = [];
  List<String> sceneScriptscene = [];
  List<String> conversation = [];
  List<String> animalScene = [];
  List<String> conversationScene = [];
  List<String> places = [];
  List<String> animalUrl = [];
  List<Map<String, dynamic>> scene = [];
  List<MapEntry<String, String>> scriptParts = [];

  bool showCircles = false;
  bool isLoading = true;

  int currentIndex = 0;
  int noScenes = 0;
  int noCurrentAnimals = 0;
  int startIndex = 0;

  int w = 0;
  int n = 0;
  double small = 600;
  double large = 560;

  Future<int> NoScene() async {

    noScenes = await sqfLite.getSceneCountByStoryName(widget.storyName);
    print(noScenes);
    return noScenes;
  }

  Future<List<Map>> ReadData() async {
    List<Map> response = await sqfLite.readAnimalData();
    print(response);
    return response;
  }

  List<String> split(String input) {
    String stringWithoutBrackets = input.replaceAll(RegExp(r'[\[\]]'), '');

    List<String> resultList = stringWithoutBrackets.split(',').map((e) => e.trim()).toList();

    return resultList;
  }

  Future Retrieve(int Index) async {
    place = await sqfLite.getUrlByPlaceName(places[Index]);
    animalScene = split(animal[Index]);
    conversationScene = split(conversation[Index]);
    sceneScriptscene = split(sceneScript[Index]);
    print("sceneScripttttttttttttttttttttttttttttttttttt");
    print(sceneScript);
    print(sceneScriptscene);
    parseSceneScript(Index);
    print(scriptParts);
    _text = scriptParts[currentIndex].value;
    _speak();




    startIndex = animalScene.length;

    print('animal leng' + "${startIndex}");

    for (var character in animalScene) {
      var url = await sqfLite.getUrlByAnimalName(character);
      animalUrl.add(url);
    }
    isLoading = false;
    setState(() {});
  }

  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
    }

  Future<List<Map<String, dynamic>>> Retrievee() async {
    try {
      List<Map<String, dynamic>> scenes = await sqfLite.getAllScenesByStoryName(widget.storyName);

      for (var s in scenes) {
        print("$s");
        places.add(s['place']);
        animal.add(s['chars']);
        conversation.add(s['conversation']);
        sceneScript.add(s['sceneScript']) ;
      }

      print(sceneScript);
      Retrieve(0);
      return scenes;
    } catch (e) {
      print('Error retrieving scenes: $e');
      return [];
    }
  }

  void parseSceneScript(int Index) {
    final regex = RegExp(r'^[a-zA-Z]+:');
    final sentences = sceneScriptscene.toString()?.split('\n');
    for (var sentence in sentences!) {
      // Remove "[" and "]" characters from the sentence
      sentence = sentence.replaceAll('[', '').replaceAll(']', '');

      if (regex.hasMatch(sentence)) {
        // This is a dialogue
        final parts = sentence.split(':');
        final character = parts[0];
        final dialogue = parts.sublist(1).join(':').trim();
        scriptParts.add(MapEntry(character, dialogue));
      } else {
        // This is a normal sentence
        scriptParts.add(MapEntry('', sentence));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeTts();


    print('widget.storyName');
    print(widget.storyName);

    NoScene().then((_) {
      Retrievee().then((_) {
        if (scriptParts.isNotEmpty) {
          setState(() {
            _text = scriptParts[currentIndex].value;
            _speak();
          });
        }
      });
    });
  }

  Future<void> _initializeTts() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(0.5);
      await flutterTts.setSpeechRate(0.5);
    } catch (e) {
      print("Error initializing TTS: $e");
    }
  }

  Future<void> _speak() async {
    try {
      await flutterTts.speak(_text);
    } catch (e) {
      print("Error speaking: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    CarouselController buttonCarouselController = CarouselController();

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: FlutterCarousel(
                items: List.generate(noScenes, (index) => content(index)),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      w = 0;
                      currentIndex=0;
                      small = 600;
                      large = 560;
                      animalUrl.clear();
                      scriptParts.clear();
                      Retrieve(index);
                    });
                  },
                  controller: buttonCarouselController,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  aspectRatio: 2.0,
                  initialPage: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget content(int Index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = (currentIndex + 1) % scriptParts.length;
          updateCirclePositions();
          if (scriptParts[currentIndex].key.isNotEmpty) {
            w = (w + 1) % animalScene.length;
          }
          _text = scriptParts[currentIndex].value;
          _speak();
        });
      },
      child: SizedBox(
        child: Stack(
          children: [
            Center(
              // place
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(place!),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: InkWell(
                onTap: (){
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>Navigation(isAuthor: widget.isAuthor, userName: widget.userName, create:false , firstScene: true)));
                },
                child: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 50,
                ) ,
              ) ,
            ),
            if (scriptParts.isNotEmpty)
              Positioned(
                top: 20,
                right: 220,
                child: scriptParts[currentIndex].key.isNotEmpty
                    ? Container(
                  height: 190,
                  width: 380,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/cloudd.png"),
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(60.0),
                    child: Container(
                      width: 120,
                      height: 300,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            scriptParts[currentIndex].value,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    : Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width *.7 ,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          scriptParts[currentIndex].value,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                  ),
                ),
                    ),
              ),
            if (scriptParts.isNotEmpty && scriptParts[currentIndex].key.isNotEmpty)
              Positioned(
                top: 240,
                right: small,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 3),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            if (scriptParts.isNotEmpty && scriptParts[currentIndex].key.isNotEmpty)
              Positioned(
                top: 190,
                right: large,
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 3),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            if (animalUrl.length >= 1 && startIndex >= 1)
              Positioned(
                bottom: -20,
                left: 50,
                child: Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    child: animalUrl[0] != null
                        ? Image.network(animalUrl[0]!, fit: BoxFit.cover)
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
            if (animalUrl.length >= 2 && startIndex >= 2)
              Positioned(
                bottom: -20,
                right: 50,
                child: Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    child: animalUrl[1] != null
                        ? Image.network(animalUrl[1]!, fit: BoxFit.cover)
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
            if (animalUrl.length >= 3 && startIndex >= 3)
              Positioned(
                bottom: -20,
                right: MediaQuery.of(context).size.width * 0.5 - 100,
                child: Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    child: animalUrl[2] != null
                        ? Image.network(animalUrl[2]!, fit: BoxFit.cover)
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  void updateCirclePositions() {
    if (w == 0) {
      small = 550;
      large = 520;
    } else if (w == 1) {
      small = 220;
      large = 250;
    } else {
      small = 400;
      large = -200;
    }
    showCircles = scriptParts[currentIndex].key.isNotEmpty;
  }
}
