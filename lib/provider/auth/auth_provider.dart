import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/models/user_model.dart';
import 'package:login/view/screens/auth/login_screen.dart';
import 'package:login/view/screens/chat/chat_screen.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  GoogleSignIn _googleSignIn=GoogleSignIn();

  void Login(String email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.to(ChatScreen());
      Get.offAll(ChatScreen());
    } catch (e) {
      Get.snackbar(
          "Lohin error ",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange
      );
    }
  }

  void signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    Get.offAll(LoginScreen());
  }

  void register(String email, password,name) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password).then((user) async{
            saveUser(user, name);
      });
      Get.offAll(ChatScreen());
    } catch (e) {
      Get.snackbar(
          "Signout error ",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange
      );

    }
  }
  void googleSignin () async {
    final GoogleSignInAccount? googleuser=await _googleSignIn.signIn();
    print(googleuser);

    GoogleSignInAuthentication googleSignInAuthentication=
    await googleuser!.authentication;

   final AuthCredential credential= GoogleAuthProvider.credential(idToken:googleSignInAuthentication.idToken ,
        accessToken:googleSignInAuthentication.accessToken );

    await _auth.signInWithCredential(credential).then((value){
      saveUser(value, "");
      Get.offAll(ChatScreen());

    });

  }

  saveUser(UserCredential user , String name)async{
    UserModel userModel=UserModel(name: name==""?user.user!.displayName! :name,
        email: "",
        image: "",
        userId: user.user!.uid);
    await _firestore.collection("users").doc(user.user!.uid).set(userModel.toJson());

  }


}