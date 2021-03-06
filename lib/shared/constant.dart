import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(

    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green,width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFFF0000) ,width: 2.0),
    )
);

const razer_bg = BoxDecoration(
    image: DecorationImage(
        image: AssetImage('assets/images/razer.png'),
        fit: BoxFit.cover
    )
);