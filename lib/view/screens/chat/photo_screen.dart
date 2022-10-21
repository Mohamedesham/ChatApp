import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/provider/chat/photo_provider.dart';
import 'package:provider/provider.dart';

import '../../../provider/chat/chat_provider.dart';


class PhotoScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var image = Provider.of<ChatProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Photo Screen'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(image.userModel.image==""?"not found":image.userModel.image),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(onPressed: () {
                  Provider.of<PhotoProvider>(context,listen: false).getImage(ImageSource.camera);
                },
                  elevation: 10,
                  height: 40,
                  minWidth: 150,
                  color: Colors.teal,
                  child: Text("add image from camera",style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 20,),
                MaterialButton(onPressed: () {
                  Provider.of<PhotoProvider>(context,listen: false).getImage(ImageSource.gallery);
                },
                  elevation: 10,
                  height: 40,
                  minWidth: 150,
                  color: Colors.teal,
                  child: Text("add image from gallery",style: TextStyle(color: Colors.white),),
                )
              ],
            )
          ],
        )
    );
  }
}