import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:mychatapp/Home/mainscreen.dart';
import 'package:mychatapp/helper/authenticate.dart';
import 'package:mychatapp/helper/helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  !kIsWeb ? await Firebase.initializeApp(
    name: 'chatapp-1816a',
    options: const FirebaseOptions (
      apiKey: "AIzaSyCJEVh9spVa-RkJLMLB5tTNdOvYdU9eilo",
      authDomain: "chatapp-1816a.firebaseapp.com",
      projectId: "chatapp-1816a",
      storageBucket: "chatapp-1816a.appspot.com",
      messagingSenderId: "949383318",
      appId: "1:949383318:web:5bed8401884c54e65b12b7",
      measurementId: "G-LQ2B244W7K"
   )
   ) : await Firebase.initializeApp(
    options: const FirebaseOptions (
      apiKey: "AIzaSyCJEVh9spVa-RkJLMLB5tTNdOvYdU9eilo",
      authDomain: "chatapp-1816a.firebaseapp.com",
      projectId: "chatapp-1816a",
      storageBucket: "chatapp-1816a.appspot.com",
      messagingSenderId: "949383318",
      appId: "1:949383318:web:5bed8401884c54e65b12b7",
      measurementId: "G-LQ2B244W7K"
   )
   );
   SystemChrome.setSystemUIOverlayStyle(
     const SystemUiOverlayStyle(
       statusBarColor: Colors.transparent,
       statusBarBrightness: Brightness.light
     )
   );
   runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isuserloggedin=false;

  @override
  void initState() {
    getloggedinstate();
    super.initState();
  }

  getloggedinstate() async {
    return await helpermethod.getuserloggedinsharedpreference().then((value) {
      if(value == null) {
          return;
      }
      setState(() {
        isuserloggedin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isuserloggedin ? const HomeScreen() : const Authenticate(),
      title: "MyChatApp"
    );
  }
}