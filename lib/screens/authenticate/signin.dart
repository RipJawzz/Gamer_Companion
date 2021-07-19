import 'package:flutter/material.dart';
import 'package:game_companion/services/auth.dart';
import 'package:game_companion/shared/constant.dart';
import 'package:game_companion/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email='',password='',error='';

  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0.0,
        title: Text(
          'Sign into Gamer Companion',
        ),
        actions: [
          TextButton.icon(
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            label: Text('Register',
            style: TextStyle(
              color: Theme.of(context).primaryColor
            ),),
            onPressed: (){
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                onChanged: (val){
                  setState(() {
                    email=val;
                  });
                },
                validator: (val)=>val!.isEmpty?'Enter an email':null,
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                onChanged: (val){
                  password=val;
                },
                obscureText: true,
                validator: (val)=>val!.length<=6?'Enter a password 6+ char long':null,
              ),
              SizedBox(height: 20,),
              RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    setState(() => loading=true);
                    dynamic result =await _auth.signInWithEmailAndPwd(email, password);
                    if(result==null){
                      setState(() {
                        loading=false;
                        error = 'invalid credentials';
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 20,),
              Text(error,
                style: TextStyle(
                    color:  Colors.red,
                    fontSize: 14.0
                ),
              ),
            ],
          ),
        ),
        decoration: razer_bg,
      ),
    );
  }
}
