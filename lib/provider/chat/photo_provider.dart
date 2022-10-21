import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  FirebaseStorage storage = FirebaseStorage.instance;

  FirebaseAuth auth =FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void getImage(ImageSource src) async {
    final XFile? pickedImageFile = await _picker.pickImage(source: src,imageQuality: 50,maxWidth: 300,maxHeight: 300);

    if(pickedImageFile !=null){
      File pickImage = File(pickedImageFile.path);

      await storage.ref().child(auth.currentUser!.uid + ".jpg").putFile(pickImage);

      final url = await storage.ref().child(auth.currentUser!.uid + '.jpg').getDownloadURL();

      await firestore.collection("users").doc(auth.currentUser!.uid).update({
        "image": url
      });

      firestore.collection("message").where("uId", isEqualTo: auth.currentUser!.uid).get().then((value) {
        value.docs.forEach((element) {
          firestore.collection("message").doc(element.id).update({"avatarUrl": url});
        });
      });

      notifyListeners();

    }else{
      print("image noy found");
    }
  }
}