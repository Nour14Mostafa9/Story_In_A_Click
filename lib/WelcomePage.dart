import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(" Welcome",
                  style: TextStyle(color: Color(0xffB04BA2), fontSize: 60,fontWeight: FontWeight.bold ),),
                Image.asset( "assets/welcomepage.png",width: 400,height: 380,),
                const Text(" LET'S",
                  style: TextStyle(color: Color(0xffB04BA2), fontSize: 45,fontWeight: FontWeight.bold ),),
                const Text(" READ",
                  style: TextStyle(color: Color(0XFFCFADAD), fontSize: 45,fontWeight: FontWeight.bold ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){}, child: const Text("Next",style: TextStyle(color: Colors.grey,fontSize: 28),)),
                  ],
                )

              ],
            ),
          )),
    );
  }
}
