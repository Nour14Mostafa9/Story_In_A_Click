import 'package:first/Login.dart';
import 'package:first/Component/profileIcon.dart';
import 'package:first/SqfLiteHelper/Sqflite.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String username;
  final String? mail;
  final String? pass;

  Profile({super.key, required this.username, required this.pass, required this.mail});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = "";
  String? email = "";
  String? password = "";
  Sqflite sqflite = Sqflite();

  final name=TextEditingController();
  final passwordController=TextEditingController();

  var formKey = GlobalKey<FormState>();

  late SharedPreferences loginData;
  bool edit = false;

  Future<void> getUserInfo() async {
    userName = widget.username;
    email = await sqflite.getEmailByUsername(userName);
    password = await sqflite.getPasswordByUsername(userName);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: edit
                    ? Form(
                  key: formKey,
                      child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60,),
                        Text(
                          "${widget.username}'s Profile",
                          style: const TextStyle(
                              color: Color(0xffB04BA2),
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 50,),
                        Container(
                            height: 500,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: const Color(0xffCFADAD),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 50,),
                                 Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text(
                                        "Email :   $email ",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30,),
                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * .7,
                                    height: MediaQuery.of(context).size.width * .14,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextFormField(
                                      controller: name,
                                      style: const TextStyle(color: Color(0xffB04BA2)),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter Name";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        labelText:"EDIT YOUR USERNAME",
                                        labelStyle: const TextStyle(
                                            color: Color(0xffB04BA2), fontSize: 18),
                                        hintMaxLines: 3,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xffB04BA2), width: 2),
                                            borderRadius: BorderRadius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30,),

                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * .7,
                                    height: MediaQuery.of(context).size.width * .14,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextFormField(
                                      controller: passwordController,
                                      style: const TextStyle(color: Color(0xffB04BA2)),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please Enter Name";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        labelText:"EDIT YOUR NEW PASSWORD",
                                        labelStyle: const TextStyle(
                                            color: Color(0xffB04BA2), fontSize: 18),
                                        hintMaxLines: 3,
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color(0xffB04BA2), width: 2),
                                            borderRadius: BorderRadius.circular(20.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 90,),
                                Center(
                                  child: ProfileContainer(
                                      text: 'Save', onpress: () async {
                                    setState(() {
                                      if (formKey.currentState!.validate()) {
                                        sqflite.updateInfo(password: passwordController.text, username: name.text);
                                      }

                                      edit = !edit;
                                    });
                                  }),
                                )
                              ],
                            )),
                      ],
                  ),
                ),
                    ) : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${widget.username}'s Profile",
                      style: const TextStyle(
                          color: Color(0xffB04BA2),
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 50,),
                    Container(
                        height: 500,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xffCFADAD),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .7, top: 30),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    edit = !edit;
                                  });
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.edit, color: Color(0xffB04BA2),),
                                  radius: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text("Name : ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    "${ widget.username}", style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30,),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text("Email :",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    "${email}", style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30,),
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Text("Password :",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    "$password", style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),

                              ],
                            ),

                            SizedBox(
                              width: 180,
                              child: ProfileContainer(
                                  text: 'SIGN OUT', onpress: () async {
                                loginData = await SharedPreferences.getInstance();
                                loginData.setBool('login', false);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              }),
                            )
                          ],
                        )
                    ),
                  ],
                ),
              );
            }
          }
      ),
    );
  }
}
