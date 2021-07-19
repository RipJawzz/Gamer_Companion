// @dart=2.9
import 'package:flutter/material.dart';
import 'package:game_companion/screens/wrapper.dart';
import 'package:game_companion/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:game_companion/data_and_models/user.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Gamer sub branch',
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.greenAccent[700],
        ),
        home: SafeArea(child: Wrapper()),
        debugShowCheckedModeBanner: false,
      ),

    );
  }
}

