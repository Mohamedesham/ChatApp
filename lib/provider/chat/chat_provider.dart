import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/models/chat_model.dart';
import 'package:login/models/user_model.dart';

class ChatProvider extends ChangeNotifier {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _userId = FirebaseAuth.instance;

  Stream<List<ChatModel>> getChatScreen() {
    return _firestore.collection("message").orderBy("time",descending: true).snapshots().map((event) {
      return List<ChatModel>.from(
          event.docs.map((e) => ChatModel.fromJson(e.data())));
    });
  }

  sendMessage(ChatModel chatModel) async {
    await _firestore.collection("message").add(chatModel.toJson());
  }
  UserModel userModel=UserModel(name: "", email: "", image: "", userId: "");

  getUser() async {
    await _firestore.collection("users").doc(_userId.currentUser!.uid)
        .get()
        .then((value) {
        userModel=  UserModel.fromJson(value.data()!);

    });

  }

}
