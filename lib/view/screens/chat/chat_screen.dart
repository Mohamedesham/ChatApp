import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/models/chat_model.dart';
import 'package:login/provider/auth/auth_provider.dart';
import 'package:login/provider/chat/chat_provider.dart';
import 'package:provider/provider.dart';

import 'photo_screen.dart';

class ChatScreen extends StatelessWidget {
  var message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatProvider>(context).getUser();
    var userProvider = Provider.of<ChatProvider>(context);
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        // color whats app
        appBar: AppBar(
          backgroundColor: Color(0xff075E54),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxO9X2ed1qmzL-fzamLgppCaX8fI6Nvfs7LoUEpbwY&s'),
          ),
          title: Text("Chat app"),
          actions: [
            PopupMenuButton(onSelected: (x) {
              if (x == 1) {
                Get.to(PhotoScreen());
              } else {
                Provider.of<AuthProvider>(context,listen: false).signOut();
              }
            }, itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle_outlined,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Profile'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            })
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: Provider.of<ChatProvider>(context).getChatScreen(),
                  builder: (context, snapshot) {
                    List<ChatModel> chatList = snapshot.data ?? [];
                   return ListView.builder(
                      reverse: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        bool isMe = chatList[index].userId==user!.uid;

                        return isMe?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    'https://wallpapercave.com/wp/wp3019726.jpg'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatList[index].name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      chatList[index].message,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ):
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    'https://wallpapercave.com/wp/wp3019726.jpg'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatList[index].name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      chatList[index].message,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      itemCount: chatList.length,
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: message,
                      decoration: InputDecoration(
                          hintText: "Type message",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        Provider.of<ChatProvider>(context, listen: false)
                            .sendMessage(ChatModel(
                                userId: userProvider.userModel.userId,
                                name: userProvider.userModel.name,
                                message: message.text,
                                time: DateTime.now().toString(),
                                avatarUrl: userProvider.userModel.image));
                        message.clear();
                        FocusScope.of(context).unfocus();
                      },
                      child: Icon(
                        Icons.send,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
