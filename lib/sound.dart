import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


class TextToSpeechScreen extends StatefulWidget {


  @override
  _TextToSpeechScreenState createState() => _TextToSpeechScreenState();
}

class _TextToSpeechScreenState extends State<TextToSpeechScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String _text = "Once upon a time, in a land far away, there lived a wise old owl.";

  Future<void> _speak() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(2);
    await flutterTts.setSpeechRate(1);
    await flutterTts.speak(_text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text to Speech"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Enter text to speak"),
              onChanged: (String value) {
                setState(() {
                  _text = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speak,
              child: Text("Speak"),
            ),
          ],
        ),
      ),
    );
  }
}





