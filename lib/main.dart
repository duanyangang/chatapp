import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:last_try/helper/Authenticate.dart';
import 'package:last_try/helper/constants.dart';
import 'package:last_try/helper/helperFunctions.dart';
import 'package:last_try/views/ChatRoomScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn;
  @override
  void initState() {
    // getLoggedInState();
    super.initState();
    print(Constants.myName);
  }

  // getLoggedInState() async {
  //   await HelperFunctions.getUserLoggedInSharedPreference().then((val) {
  //     setState(() {
  //       userIsLoggedIn = val;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null
          ? /**/ userIsLoggedIn!
              ? ChatRoom()
              : Authenticate() /**/ : Authenticate(),
    );
  }
}

// class MainScreen extends StatefulWidget {
//   // const MainScreen({ Key? key }) : super(key: key);

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   @override
//   void initState() {
//     super.initState();

//     upload();
//   }

//   Future upload() async {
//     await Firebase.initializeApp();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar(), body: Authenticate());
//   }
// }
