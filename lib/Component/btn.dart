import 'package:first/Navigation.dart';
import 'package:flutter/material.dart';

class BtnReg extends StatelessWidget {
   BtnReg({required this.txt,required this.onpress});

   String? txt;
   Function() onpress;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 239,
      height: 81,
      child: ElevatedButton(
          style:ElevatedButton.styleFrom(
            elevation: 10,
            backgroundColor:  const Color(0xffB04BA2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),

            ),
          ),
          onPressed: onpress,
          child:  Text(txt!, style: TextStyle(color: Colors.white, fontSize: 20),)),
    );
  }
}
