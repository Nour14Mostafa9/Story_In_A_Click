import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  String _predictedEmotion = '';
  double _probability = 0.0;

  void _predictEmotion(String text) async {
    try {
      Response response = await Dio().post(
        'http://10.0.2.2:8000/predict-emotion/',
        data: {'text': text},
      );
      Map<String, dynamic> data = response.data;
      setState(() {
        _predictedEmotion = data['predicted_emotion'];
        _probability = data['probability'];
      });
    } catch (e) {
      print('Error predicting emotion: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotion Recognition'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter text',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _predictEmotion(_textController.text);
              },
              child: Text('Predict Emotion'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Predicted Emotion: $_predictedEmotion\nProbability: $_probability',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}