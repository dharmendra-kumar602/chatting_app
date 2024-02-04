import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/chattingApp/HomeScreen.dart';
import 'package:firebase/chattingApp/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount(String name, String email, String password) async{
FirebaseAuth _auth= FirebaseAuth.instance;

FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try{
      User? user = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      if(user!=null){
        print('Account Create Succesfull');

        user.updateProfile(displayName: name);
        _firestore.collection('users').doc(_auth.currentUser?.uid).set({
          "name":name,
          "email":email,
          "status":"Unavailable",
          "uid":_auth.currentUser?.uid,
        });
        return user;
      }else{
        print('Account Creation failed');
        return user;
      }
    } catch (e){
      print(' Create Account exception erro : ${e}');
    }
}

Future<User?> login(String email, String password,BuildContext context) async{
FirebaseAuth _auth= FirebaseAuth.instance;
    try{
      User? user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
      if(user!=null){
        print('Login  Succesfull');
        Navigator.push(context,MaterialPageRoute(builder: (context) =>HomeScreen()));

        return user;
      }else{
        print('Login failed');
        return user;
      }
    } catch (e){
      print(' Login exception error : ${e}');
    }
}


Future logOut(BuildContext context) async {
  FirebaseAuth _auth= FirebaseAuth.instance;
  try{
    await _auth.signOut().then((value) {
      Navigator.push(context,MaterialPageRoute(builder: (context) =>LoginScreen()));

    });
    print("Log out succesfull");


  }catch (e){
    print("Log out faild exception ");
  }
}
