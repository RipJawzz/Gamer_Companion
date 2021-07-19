import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_companion/data_and_models/game_data.dart';
import 'package:game_companion/screens/tabs/mostpopular.dart';
import 'package:game_companion/screens/tabs/others_playing.dart';
import 'package:game_companion/screens/tabs/selected_List.dart';

class Categories extends StatefulWidget {
  const Categories();

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int selectedIndex = 0;
  final List<String> categoriesOptions = [
    'All Games',
    'Favourites',
    'Most Popular',
    'Playing',
  ];

  @override
  void initState(){
    sortedLikes.clear();
    all_games_alphabetically.clear();
    for(var i in all_games){
      sortedLikes.add(i);
      all_games_alphabetically.add(i);
    }
    all_games_alphabetically.sort((a,b) => a.name.compareTo(b.name));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          height: 50.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesOptions.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Text(
                      categoriesOptions[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: index == selectedIndex
                            ? Colors.black
                            : Colors.grey[700],
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              }),
        ),
        category_selected(categoriesOptions[selectedIndex]),
      ],
    );
  }

  Widget category_selected(String selected) {
    Widget widget = Text(
      'Holder',
      style: TextStyle(color: Colors.white),
    );
    switch (selected) {
      case 'All Games':
        widget = Selected_List(list: all_games_alphabetically,);
        break;
      case 'Favourites':
        if (favourites.length == 0)
          widget = Expanded(
            child: Column(
              children: [
                Flexible(flex: 18,child: Image(image: AssetImage('assets/images/holder2.png'))),
                SizedBox(height: 20),
                Flexible(
                  flex: 2,
                  child: Text(
                    'No favourites added yet!',
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          );
        else {
          print(favourites.length);
          widget = Selected_List(list: favourites,);
        }
        break;
      case 'Most Popular':
        widget=mostPopular();
        break;
      case 'Playing':
        widget=OthersNowPlaying();
        break;
      default:
        widget = Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(

            children: [
              Image(image: AssetImage('assets/images/coming.png')),
              SizedBox(height: 20),
              Text(
                'Coming soon!',
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
        );
    }
    return widget;
  }
}
