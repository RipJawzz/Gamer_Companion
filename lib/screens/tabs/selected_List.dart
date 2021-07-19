import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_companion/data_and_models/game.dart';
import 'package:game_companion/data_and_models/game_data.dart';
class Selected_List extends StatefulWidget {
  final List<game> list;
  const Selected_List({Key? key,required this.list}) : super(key: key);

  @override
  _Selected_ListState createState() => _Selected_ListState();
}

class _Selected_ListState extends State<Selected_List> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView.builder(
            itemCount: widget.list.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              game curr = widget.list[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.greenAccent,
                ),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),

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
                              color: favourites.contains(curr)? Colors.red : Colors.white,
                            ),
                            IconButton(onPressed : (){
                              setState((){
                                if(nP==curr.code)
                                  nP=0;
                                else
                                  nP=curr.code;
                            });
                            }
                            , icon: Icon(
                                  curr.code==nP?
                                  Icons.watch_later:
                                      Icons.watch_later_outlined
                                ),
                            ),
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
  }
}
