import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_companion/data_and_models/game_data.dart';
import 'package:game_companion/data_and_models/user.dart';
import 'database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on firebase user
  User? _userFromFireBase(FirebaseUser user){
    return user!=null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User?> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFireBase);
  }

  //sign in anonymously
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFireBase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
//sign in with email and pwd
  Future signInWithEmailAndPwd(String email,String password) async{
    try{
      AuthResult result=await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFireBase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

//register with email and pwd
  Future registerWithEmailAndPwd(String email,String password) async{
    try{
      AuthResult result=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      //create doc for firestore
      await DatabaseService(uid: user.uid).updateUserData('0',email.split('@')[0],0);
      return _userFromFireBase(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

//signout
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}
