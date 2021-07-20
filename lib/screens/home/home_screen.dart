import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:game_companion/Widgets/categories.dart';
import 'package:game_companion/data_and_models/game.dart';
import 'package:game_companion/data_and_models/game_data.dart';
import 'package:game_companion/data_and_models/user.dart';
import 'package:game_companion/services/auth.dart';
import 'package:game_companion/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:game_companion/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final title;

  const HomeScreen({this.title});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    Future<void> _launch(String url) async {
      try {
        launch(url);
      } catch (e) {
        print("Launch failed");
      }
    }

    void _showDevDetails() {
      showModalBottomSheet(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20,),
                    Text(
                      "Made by : Ishan Acharyya",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20,),
                    IconButton(
                      onPressed: () => _launch("https://github.com/RipJawzz"),
                      icon: Image(
                        image: AssetImage("assets/others/github.png"),
                      ),
                      iconSize: 50,
                    ),
                    SizedBox(width: 15,),
                    IconButton(
                      onPressed: () => _launch(
                          "https://www.linkedin.com/in/ishan-acharyya-297222191/"),
                      icon: Image(
                        image: AssetImage("assets/others/linkedin.png"),
                      ),
                      iconSize: 30,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Icon(Icons.email,size: 30,),
                    Text("ishanacharyya6@gmail.com",
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            );
          });
    }

    void _showSettingsPanel(String name) {
      game? curr;
      if (nP != 0) curr = all_games[nP - 1];
      showModalBottomSheet(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Playing now:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (curr == null)
                      Text(
                        'Not playing any',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    if (curr != null)
                      Text(
                        curr.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    if (curr != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: AssetImage(curr.imageUrl),
                        ),
                      ),
                  ],
                ),
              ],
            );
          });
    }

    void onSelected(BuildContext context, int item,String name) async{
      switch (item) {
        case 0:
          await _auth.signOut();
          break;
        case 1:
          _showSettingsPanel(name);
          break;
        case 2:
          _showDevDetails();
          break;
      }
    }

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            List<int> list = [];
            var s = userData!.favourites.split(',');
            nP = userData.NP;
            for (int i = 0; i < s.length; i++) {
              list.add(int.parse(s[i]));
            }
            favourites.clear();
            for (int i = 0; i < all_games.length; i++) {
              if (list.contains(all_games[i].code))
                favourites.add(all_games[i]);
            }
            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: AppBar(
                title: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /*actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    iconSize: 20,
                    color: Theme.of(context).backgroundColor,
                  ),
                  IconButton(
                      onPressed: () => _showSettingsPanel(userData.name),
                      icon: Icon(Icons.visibility),
                    iconSize: 20,
                    color: Theme.of(context).backgroundColor,
                  ),
                  IconButton(
                    onPressed: () => _showDevDetails(userData.name),
                    icon: Icon(Icons.info_outline),
                    iconSize: 20,
                    color: Theme.of(context).backgroundColor,
                  )
                ],*/
                actions: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.white,
                      iconTheme: IconThemeData(color: Colors.blue,size: 30),
                      textTheme: TextTheme().apply(bodyColor: Colors.blue)
                    ),
                    child: PopupMenuButton<int>(
                      color: Theme.of(context).primaryColor,
                      onSelected: (item) => onSelected(context, item,userData.name),
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: TextButton.icon(
                            icon: Icon(Icons.logout,),
                            onPressed: () async {await _auth.signOut();},
                            label: Text("Logout"),
                          )
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                            child: TextButton.icon(
                              icon: Icon(Icons.visibility,),
                              onPressed: () {_showSettingsPanel(userData.name);},
                              label: Text("U"),
                            )
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem<int>(
                          value: 2,
                            child: TextButton.icon(
                              icon: Icon(Icons.info,),
                              onPressed: () {_showDevDetails();},
                              label: Text("About"),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Categories(),
                    flex: 1,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        String s = '0';
                        for (int i = 0; i < favourites.length; i++)
                          s = s + ',' + favourites[i].code.toString();
                        await DatabaseService(uid: user.uid)
                            .updateUserData(s, userData.name, nP);
                      },
                      child: Text('Update'))
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
