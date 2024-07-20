import 'package:first/Component/btn.dart';
import 'package:first/Component/tff.dart';
import 'package:first/Navigation.dart';
import 'package:first/SqfLiteHelper/Sqflite.dart';
import 'package:first/progresspage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final  email=TextEditingController();
  final userName=TextEditingController();
  final nickname=TextEditingController();
  final password=TextEditingController();
  final age=TextEditingController();
  final favoriteAnimal=TextEditingController();
  var formkey = GlobalKey<FormState>();

  String usertype="qwe";

  Sqflite db= Sqflite();

  bool firstTime = true;
  late SharedPreferences loginData ;
  late SharedPreferences Author ;


  Color containerColor = const Color(0xffCFADAD);

  var formKey = GlobalKey<FormState>();
  bool isAuthor= true;
  late bool _passwordVisible ;


  @override
  void initState() {
    _passwordVisible = false;
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffFFDB5C),
      body:Form(
        key: formkey,
        child: ListView(
          children: [
            SizedBox(height: screenHeight*.12),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    Text('Create an',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 40
                      ),
                    ),
                    Text('Account',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 40
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height:83 ,
                    width: 141,
                    child: Image.asset('assets/signup_bird.png')),
              ],
            ),
            const SizedBox(height: 30,),
            Container(
            width: double.infinity,
            height: screenHeight*.7,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: const BorderRadiusDirectional.vertical(top: Radius.circular(60)),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: isAuthor == false?Image.asset('assets/rederbtn.png',
                        height: 61,
                        width: 179,
                      ): Image.asset('assets/rederbtn.png',
                        height: 61,
                        width: 179,
                      ),
                      onTap: (){
                        isAuthor = false;
                        usertype='reader';
                        print(usertype);
                        setState(() {
                          containerColor=Colors.grey;
                        });
                      },
                    ),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        isAuthor= true;
                        usertype='author';
                        print(usertype);
                        setState(() {
                          containerColor= const Color(0xffCFADAD);
                        });
                      },
                      child: isAuthor== true? Image.asset('assets/authorbtn.png',
                          height: 61,
                          width: 179
                      ): Image.asset('assets/authorbtn2.png',
                          height: 61,
                          width: 179
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 30,),
                TextFF(
                  visible: false,
                  hint:'Email' ,
                  controller: email,
                  suff: Image.asset("assets/img_2.png",width: 80,),
                  backColor: isAuthor==false? Colors.grey.shade300:Colors.white,
                  keyboardType: TextInputType.emailAddress,
                  validation:(value){
                    if(value == null || value.isEmpty ){
                      return"Please Enter Your email";
                    }else if(!value.contains("@")){
                      return"your email should  contains @";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                TextFF(
                  visible: false,
                  backColor: isAuthor==false? Colors.grey.shade300:Colors.white,
                  hint:'Username' ,
                  controller: userName,
                  keyboardType: TextInputType.visiblePassword,
                  validation:(value){
                    if(value == null || value.isEmpty){
                      return"Please Enter Your Username";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                TextFF(
                    visible:  !_passwordVisible,
                    suff: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset( _passwordVisible?"assets/owl.png":"assets/owl2.png" ,),
                      ),
                      onTap: (){
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),

                    hint:'Password' ,
                    controller: password,
                    backColor: isAuthor==false? Colors.grey.shade300:Colors.white,
                    keyboardType: TextInputType.visiblePassword,
                    validation:(value){
                      if(value == null || value.isEmpty ){
                        return"Please Enter Your password";
                      }else if( value.length < 8){
                        return"Your password is vary short ";
                      }
                      return null;
                    }
                ),

                SizedBox(height: screenHeight*.03,),

                BtnReg(txt: 'Sign Up',
                    onpress: () async {

                  if (formkey.currentState!.validate()) {
                    await db.insertUserData(
                        email: email.text,
                        username: userName.text,
                        nickname: nickname.text,
                        password: password.text,
                        age: 0,
                        favoriteAnimal: favoriteAnimal.text,
                        userType: usertype
                    );
                    check();
                    print(email.text);
                    loginData = await SharedPreferences.getInstance();
                    Author = await SharedPreferences.getInstance();
                    loginData.setBool('login', true);
                    Author.setString("username", userName.text);


                    if (usertype == 'author') {
                      Author.setBool('author', true);
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => Navigation(isAuthor: true,userName: userName.text,create: false,firstScene: true,)));
                    } else {
                      Author.setBool('author', false);
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  ProgressPage(email: userName.text)));
                    }
                  }

                })

              ],
            ),
              )
          ],
        ),
      ),
    );

  }

  void check() async {
    Sqflite db = Sqflite();
    await db.insertInitialPlaceData();
    await db.insertInitialAnimalData();
  }

}

