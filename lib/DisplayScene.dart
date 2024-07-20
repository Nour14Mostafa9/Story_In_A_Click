import 'package:first/Navigation.dart';
import 'package:first/SqfLiteHelper/Sqflite.dart';
import 'package:first/StoryCreation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DisplayScene extends StatefulWidget {
  final String place;
  final String sceneScript;
  final String StoryName;
  final String userName;
  final Map<String, String> dialogue;

  DisplayScene({
    Key? key,
    required this.place,
    required this.dialogue,
    required this.sceneScript,
    required this.StoryName,
    required this.userName,
  }) : super(key: key);

  @override
  State<DisplayScene> createState() => _DisplaySceneState();
}

class _DisplaySceneState extends State<DisplayScene> {
  final FlutterTts flutterTts = FlutterTts();
  String _text = "Once upon a time, in a land far away, there lived a wise old owl.";

  Sqflite sqfLite = Sqflite();
  String? Fanimal = '';
  String? Sanimal = '';
  String? thirdAnimal = '';
  String? place;
  String? email;
  List<String> animal = [];
  List<String> chars = [];
  List<String> conversation = [];
  bool isLoading = true;
  int currentIndex = 0;
  List<MapEntry<String, String>> scriptParts = [];

  int w = 0;
  double small = 600;
  double large = 560;
  bool showCircles = false;

  Future<List<Map>> ReadData() async {
    List<Map> response = await sqfLite.readAnimalData();
    return response;
  }

  Future<void> retrieveData() async {
    for (var character in widget.dialogue.keys) {
      chars.add(character.toLowerCase());
      conversation.add(widget.dialogue[character]!);
      var url = await sqfLite.getUrlByAnimalName(character.toLowerCase());
      animal.add(url);
    }
    place = await sqfLite.getUrlByPlaceName(widget.place);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeTts();
    retrieveData();
    parseSceneScript();
    _text = scriptParts[currentIndex].value;

    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

  }

  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,

    ]);
    super.dispose();
  }

  void parseSceneScript() {
    final regex = RegExp(r'^[a-zA-Z]+:');
    final sentences = widget.sceneScript.split('\n');
    for (var sentence in sentences) {
      if (regex.hasMatch(sentence)) {
        final parts = sentence.split(':');
        final character = parts[0];
        final dialogue = parts.sublist(1).join(':').trim();
        String cleanedDialogue = dialogue.replaceAll(RegExp(r'^"|"$'), '');
        scriptParts.add(MapEntry(character, cleanedDialogue));
      } else {
        scriptParts.add(MapEntry('', sentence));
      }
    }
  }

  Future<void> _initializeTts() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(0.5);
      await flutterTts.setSpeechRate(0.5);
      _speak();  // Call speak initially
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      currentIndex = (currentIndex + 1) % scriptParts.length;
                      updateCirclePositions();
                      if (scriptParts[currentIndex].key.isNotEmpty) {
                        w = (w + 1) % chars.length;
                      }
                      _text = scriptParts[currentIndex].value;
                      _speak();
                    });
                  },
                  child: Container(
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: 350,
                            child: place != null
                                ? Image.network(place!, fit: BoxFit.fill)
                                : CircularProgressIndicator(),
                          ),
                        ),
                        if (animal.length >= 1)
                          Positioned(
                            bottom: -20,
                            left: 50,
                            child: Container(
                              width: 200,
                              height: 200,
                              child: Fanimal != null
                                  ? Image.network(animal[0]!, fit: BoxFit.cover)
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        Positioned(
                          top: 0,
                          right: 270,
                          child: Visibility(
                            visible: scriptParts[currentIndex].key.isNotEmpty,
                            child: Container(
                              height: 150,
                              width: 300,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/cloudd.png",),
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Container(
                                  width: 200,
                                  child: Text(
                                    '${scriptParts[currentIndex].value}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 130,
                          child: Visibility(
                            visible: scriptParts[currentIndex].key.isEmpty,
                            child: Padding(
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
                        ),
                        if (showCircles) // Only show circles if it's a dialogue
                          Positioned(
                            top: 158,
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
                        if (showCircles) // Only show circles if it's a dialogue
                          Positioned(
                            top: 120,
                            right: large,
                            child: Container(
                              height: 33,
                              width: 33,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 3),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        if (animal.length >= 2)
                          Positioned(
                            bottom: -20,
                            right: 50,
                            child: Container(
                              width: 200,
                              height: 200,
                              child: Sanimal != null
                                  ? Image.network(animal[1]!, fit: BoxFit.cover)
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        if (animal.length >= 3)
                          Positioned(
                            bottom: -20,
                            right: MediaQuery.of(context).size.width * 0.5 - 100,
                            child: Container(
                              width: 200,
                              height: 200,
                              child: thirdAnimal != null
                                  ? Image.network(animal[2]!, fit: BoxFit.cover)
                                  : CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: Color(0xffB04BA2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        Fanimal = '';
                        Sanimal = '';
                        thirdAnimal = '';
                        animal.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Edit Scene",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 100),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: const Color(0xffB04BA2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        sqfLite.insertSceneData(
                            place: widget.place,
                            characters: chars.toString(),
                            storyName: widget.StoryName,
                            conversation: conversation.toString(),
                            author: widget.userName,
                            sceneScript: widget.sceneScript
                        );
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => Creation(userName: widget.userName, firstScene: false, storyName: widget.StoryName,isAuthor: true,)
                          ),
                        );
                      },
                      child: const Text(
                        "Next Scene",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateCirclePositions() {
    if (w == 0) {
      small = 600;
      large = 560;
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
