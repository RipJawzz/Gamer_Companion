import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_companion/data_and_models/game_data.dart';
import 'package:game_companion/data_and_models/user.dart';
import 'package:game_companion/services/database.dart';
import 'package:game_companion/shared/loading.dart';
import 'package:provider/provider.dart';

class OthersNowPlaying extends StatefulWidget {
  const OthersNowPlaying({Key? key}) : super(key: key);

  @override
  _OthersNowPlayingState createState() => _OthersNowPlayingState();
}

class _OthersNowPlayingState extends State<OthersNowPlaying> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserData>>(
        stream: DatabaseService.empty().userDataList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var dat = snapshot.data;
            return Expanded(
              child: Container(
                child: ListView.builder(
                    itemCount: dat!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      UserData curr = dat[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.greenAccent,
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(curr.name,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  if (curr.NP != 0)
                                    Text(all_games[curr.NP - 1].name,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            curr.NP == 0
                                ? Text(
                                    'Not Playing',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          image: AssetImage(
                                              all_games[curr.NP - 1].imageUrl),
                                        ),
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
