import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ControlProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? uId;
ControlProvider(){
  getAuth();
}
 void getAuth(){
   uId=_auth.currentUser?.uid ?? null;
   notifyListeners();
 }



}