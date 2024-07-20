import 'package:first/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

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
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image:AssetImage("assets/img.png"),
                    fit: BoxFit.cover
                )
            ),
            child: const Center(
              child: Text("")
            ),)
    );
  }

  void navToSign()async {
    await Future.delayed(const Duration(milliseconds: 2500),(){

    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const Login()));

  }

  Future validation()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    var firstTime =await sharedPreferences.getBool('login');
    setState(() {
      home = firstTime!;
    });
  }
}
