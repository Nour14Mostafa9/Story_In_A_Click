import 'package:first/Component/btn.dart';
import 'package:first/Component/tff.dart';
import 'package:first/Navigation.dart';
import 'package:first/SignUp.dart';
import 'package:first/SqfLiteHelper/Sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email=TextEditingController();
  final password=TextEditingController();
  var formkey = GlobalKey<FormState>();

  Sqflite db = Sqflite();

  bool firstTime = true;
  late SharedPreferences loginData ;
  late SharedPreferences Author ;
  late bool _passwordVisible ;
  String userName = "";


  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      backgroundColor: const Color(0xffffdb5c),
      body: Form(
        key: formkey,
        child: ListView(
          children: [
            const SizedBox(
                height: 80
            ),
            Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/pin.png"),
                      fit: BoxFit.fitHeight
                  )
              ),
            ),
            const SizedBox(
                height: 80
            ),
            TextFF(
              visible: false,
              hint:'Email' ,
              controller: email,
              suff: Image.asset("assets/img_2.png",width: 80,),
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
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
                height: 10
            ),
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
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 250.0),
              child: TextButton(
                  onPressed: (){

                  },
                  child: const Text("Forget Password ?",style: TextStyle(color: Colors.black,fontSize: 15,decoration: TextDecoration.underline),)

              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child:BtnReg(
                  txt: 'Login',
                  onpress: ()async {
                    if (formkey.currentState!.validate()) {
                      bool userExists = await db.checkUserExistence(email.text);
                      print(userExists);

                      if (userExists == true) {
                        loginData = await SharedPreferences.getInstance();
                        Author = await SharedPreferences.getInstance();
                        loginData.setBool('login', true);


                        Future<bool> checker = db.checkPasswordByEmail(
                            email.text, password.text);
                        if (await checker) {
                          String userT = await db.getUserTypeByEmail(
                              email.text);
                          userName =  (await db.getUsernameByEmail(email.text))!;
                          if (userT == 'reader') {
                            Author.setBool('author', false);
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) =>
                                    Navigation(
                                      isAuthor: false, userName: userName,create: false,firstScene: true,)));
                          }
                          else {
                            Author.setBool('author', true);
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    Navigation(
                                      isAuthor: true, userName: userName,create: false,firstScene: true,)));
                          }
                        }else{
                          AwesomeDialog(
                            context: context,
                            keyboardAware: true,
                            dismissOnBackKeyPress: false,
                            dialogType: DialogType.error,
                            animType: AnimType.bottomSlide,
                            btnCancelText: "Back",
                            btnCancelColor:  const Color(0xffFFDB5C),
                            title: 'Invalid email or password',
                            desc:
                            'please re-enter correct email or password',
                            btnCancelOnPress: () {},
                          ).show();

                        }
                      }
                      else {
                        AwesomeDialog(
                          context: context,
                          keyboardAware: true,
                          dismissOnBackKeyPress: false,
                          dialogType: DialogType.error,
                          animType: AnimType.bottomSlide,
                          btnCancelText: "Back",
                          btnCancelColor:  const Color(0xffFFDB5C),
                          title: 'Invalid email or password',
                          desc:
                          'please re-enter correct email or password',
                          btnCancelOnPress: () {},
                        ).show();

                      }
                    }

                  }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account yet?",style: TextStyle(fontSize: 16),),
                TextButton(
                    onPressed: (){

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp()));
                    }
                    ,
                    child: const Text("Sign Up",style: TextStyle(color: Color(0xffB04BA2),fontSize: 16) ,))
              ],
            )



          ],
        ),
      ),
    );
  }




}
