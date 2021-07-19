import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_companion/data_and_models/user.dart';

class DatabaseService {
  String uid = '';
  DatabaseService({required this.uid});
  DatabaseService.empty();

  // collection reference
  final CollectionReference gamerData = Firestore.instance.collection(
      'gamer_companion');


  Future updateUserData(String favourites, String name, int NP) async {
    return await gamerData.document(uid).setData({
      'favourites': favourites,
      'name': name,
      'NP': NP
    });
  }

  //likelist from snapshot
  List<List<int>> _likedListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      List<int> list = [];
      var s = doc.data['favourites'].toString().split(',');
      for (int i = 0; i < s.length; i++) {
        list.add(int.parse(s[i]));
      }
      return list;
    }).toList();
  }

  Stream<List<List<int>>> get likes {
    return gamerData.snapshots().map(_likedListFromSnapshot);
  }

  //user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(favourites: snapshot.data['favourites'],
        name: snapshot.data['name'],
        NP: snapshot.data['NP']);
  }

  Stream<UserData> get userData {
    return gamerData.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  //likelist from snapshot
  List<UserData> _userDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserData(favourites: doc.data['favourites'], name: doc.data['name'], NP: doc.data['NP']);
    }).toList();
  }

  Stream<List<UserData>> get userDataList {
    return gamerData.snapshots().map(_userDataListFromSnapshot);
  }
}