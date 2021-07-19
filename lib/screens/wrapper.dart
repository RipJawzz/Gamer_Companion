
import 'package:flutter/material.dart';
import 'package:game_companion/data_and_models/user.dart';
import 'package:game_companion/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    //return either home or authenticate widget
    if(user==null)
      return Authenticate();
    else {
      return HomeScreen(title: 'Gamer Companion',);
    }
  }
}
