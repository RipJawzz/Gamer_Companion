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

    void _showSettingsPanel(String name) {
      game? curr;
      if(nP!=0)
        curr=all_games[nP-1];
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
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
                    SizedBox(width: 30,),
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
                    Text('Playing now:',
                    style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 5,),
                    if(curr==null)Text('Not playing any',style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold
                    ),),
                    if(curr!=null)Text(curr.name,style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold
                    ),),
                    if(curr!=null)ClipRRect(
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
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: <Widget>[
                  TextButton.icon(
                    icon: Icon(Icons.person),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    label: Text('Logout'),
                  ),
                  TextButton.icon(
                      onPressed: () => _showSettingsPanel(userData.name),
                      icon: Icon(Icons.visibility),
                      label: Text('U'))
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
                            .updateUserData(s, userData.name,nP);
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
