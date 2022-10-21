import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/provider/chat/photo_provider.dart';
import 'package:login/view/screens/chat/chat_screen.dart';
import 'package:provider/provider.dart';




import 'provider/auth/auth_provider.dart';
import 'provider/chat/chat_provider.dart';
import 'provider/control_provider.dart';
import 'view/screens/auth/login_screen.dart';
import 'view/widget/control_view.dart';




void main()async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ChatProvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => ControlProvider()),
    ChangeNotifierProvider(create: (context) => PhotoProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: ControlView(),
    );
  }
}


