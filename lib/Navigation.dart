import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:first/Explore.dart';
import 'package:first/Favorites.dart';
import 'package:first/Profile.dart';
import 'package:first/DashBoard.dart';
import 'package:first/SqfLiteHelper/Sqflite.dart';
import 'package:first/StoryCreation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Navigation extends StatefulWidget {

  bool isAuthor ;
  String userName;
  bool create;
  bool firstScene;

  Navigation({Key? key, required this.isAuthor, required this.userName ,  required this.create,required this.firstScene}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  int selectedPage=0;

  List<Widget> readerPages = [];
  List<Widget> authorPages = [];

  String userName= "";
  String? email= "";
  String? password= "";
  Sqflite sqflite = Sqflite();

  void getUserIngo () async{
    userName = widget.userName;
    email = await sqflite.getEmailByUsername(userName);
    password = await sqflite.getPasswordByUsername(userName);

  }



  @override
  void initState() {
    super.initState();
    getUserIngo();

    authorPages = [
      DashBoard(username: widget.userName,isAuthor:widget.isAuthor,),
      Creation(userName: widget.userName,firstScene: widget.firstScene
        ,storyName:"",isAuthor: widget.isAuthor,),
      Profile(username: widget.userName,mail:email ,pass: password),
    ];
    readerPages = [
      DashBoard(username: widget.userName,isAuthor:widget.isAuthor,),
      Favorites(isAuthor: widget.isAuthor,username: widget.userName),
      Profile(username: widget.userName,mail:email ,pass: password),
    ];



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
            index:selectedPage ,
            backgroundColor:Colors.transparent.withOpacity(.1),
            color: const Color(0xffCFADAD),
            animationDuration:const Duration(milliseconds: 300),
            onTap: (index){
               getUserIngo();
              setState(() {
                selectedPage=index;
              });
            },
            items:widget.isAuthor == false?[
              Image.asset("assets/home.png",width: 45,height: 45,),
              Image.asset("assets/star.png",width: 50,height: 50,),
              Image.asset("assets/boy.png",width: 45,height: 50,),

            ]:[
              Image.asset("assets/home.png",width: 45,height: 45,),
              Image.asset("assets/addicon.png",width: 58,height: 60,),
              Image.asset("assets/authoricon.png",width: 50,height: 50,),
            ]

        ),
        body:widget.isAuthor== false?readerPages.elementAt(selectedPage):authorPages.elementAt(selectedPage)
    );
  }
}
