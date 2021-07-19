import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_companion/data_and_models/game.dart';
import 'package:game_companion/data_and_models/game_data.dart';
import 'package:game_companion/data_and_models/user.dart';
import 'package:game_companion/services/database.dart';
import 'package:game_companion/shared/loading.dart';
import 'package:provider/provider.dart';

class mostPopular extends StatefulWidget {
  const mostPopular({Key? key}) : super(key: key);

  @override
  mostPopular_State createState() => mostPopular_State();
}

class mostPopular_State extends State<mostPopular> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<List<int>>>(
        stream: DatabaseService.empty().likes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var _likeList =
                new List.filled(all_games.length + 1, 0, growable: false);
            for (int i = 0; i < all_games.length; i++) {
              all_games[i].likes = 0;
            }
            var dat = snapshot.data;
            for (int i = 0; i < dat!.length; i++) {
              for (int i1 = 0; i1 < dat[i].length; i1++) {
                _likeList[dat[i][i1]]++;
              }
            }
            for (int i = 0; i < all_games.length; i++)
              all_games[i].likes = _likeList[all_games[i].code];
            sortedLikes.sort((b, a) => a.likes.compareTo(b.likes));

            return Expanded(
              child: Container(
                child: ListView.builder(
                    itemCount: sortedLikes.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      game curr = sortedLikes[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.greenAccent,
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              curr.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      image: AssetImage(curr.imageUrl),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (!favourites.contains(curr)) {
                                            favourites.add(curr);
                                          } else {
                                            favourites.remove(curr);
                                          }
                                        });
                                      },
                                      icon: Icon(favourites.contains(curr)
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      iconSize: 50,
                                      color: favourites.contains(curr)
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                    Text(
                                      curr.likes.toString(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
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
