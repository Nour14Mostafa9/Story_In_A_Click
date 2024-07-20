import 'package:first/Display.dart';
import 'package:first/DisplayScene.dart';
import 'package:first/FirstScene.dart';
import 'package:first/Login.dart';
import 'package:first/Navigation.dart';
import 'package:first/Profile.dart';
import 'package:first/DashBoard.dart';
import 'package:first/SignUp.dart';
import 'package:first/Splash.dart';
import 'package:first/StoryCreation.dart';
import 'package:first/homepage.dart';
import 'package:first/sound.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

//lion : hi
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? login = prefs.getBool("login");
  bool? Author = prefs.getBool("author");
  String? username = prefs.getString("username");
  print("login:" + login.toString());
  WidgetsFlutterBinding.ensureInitialized();
  //runApp( MyApp(username: username!,));
  runApp(  MyApp());
  /*
  * MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.lailaTextTheme()),
      debugShowCheckedModeBanner: false,
      home: login == true ? Navigation(isAuthor: Author!, email: username!,create: false,): const SplashScreen() )*/


}


class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
        home: Navigation(isAuthor: true,userName: 'nour',firstScene: false,create: false),
    );
  }
}


