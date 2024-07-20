import 'package:flutter/material.dart';

class ProfileContainer extends StatelessWidget {
   ProfileContainer({super.key,this.text,required this.onpress});

  String? text;
  Function() onpress;



   @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: 150,
        child: GestureDetector(
          onTap:onpress ,
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
                color: Colors.white
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text!,
                  style: const TextStyle(
                      color: Color(0xffB04BA2),
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
