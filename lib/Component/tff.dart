import 'package:flutter/material.dart';

class TextFF extends StatelessWidget {
  TextFF({
    required this.hint,
    this.suffix,
    required this.controller,
     required this.validation,
    this.keyboardType,
    this.textColor,
    this.backColor,
    this.textSize,
    this.iconWidth,
    this.suff,
    required this.visible,

  });

  String? hint;
  String? suffix;
  TextEditingController? controller;
   String ? Function(String?) validation;
  TextInputType? keyboardType;
  Color ? textColor;
  Color ? backColor;
  double? textSize;
  double? iconWidth;
  bool visible;
  Widget? suff;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child:  Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(

            color: backColor ?? Colors.white,
            borderRadius: BorderRadius.circular(30)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: TextFormField(
            obscureText: visible,
            style: TextStyle(
                color: textColor,
                fontSize: textSize
            ),
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
                suffixIcon: suff,
                hintText: hint,
                border: InputBorder.none
            ),

            validator: validation,
          ),
        ),)
    );
  }
}

/*
* Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(

          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              suffixIcon: Image.asset(
                suffix,
                width: 88,

              ),
              hintText: hint,
              border: InputBorder.none
            ),

            validator: validation,
          ),
        ),*/

/*
* TextFormField(
        style: TextStyle(
          color: textColor,
          fontSize: textSize
        ),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          suffixIcon: suffix == null ? null :Image.asset(
            suffix!,
            width: 88,
          ),
          hintText: hint,
          border: InputBorder.none
        ),

        validator: validation,
      ),*/