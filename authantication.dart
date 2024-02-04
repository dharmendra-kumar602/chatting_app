import 'package:firebase/chatting%20/screen/homeScreen.dart';
import 'package:firebase/chatting%20/screen/loging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AuthanticationScreen extends StatelessWidget {
   AuthanticationScreen({super.key});

 final FirebaseAuth _auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    if(_auth.currentUser !=null){
      return HomeScreen();
    }else{
      return LoginScreen();
    }

  }
}
