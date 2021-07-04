import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_try/helper/helperFunctions.dart';
import 'package:last_try/model/database.dart';
import 'package:last_try/services/auth.dart';
import 'package:last_try/views/ChatRoomScreen.dart';

class SignUp extends StatefulWidget {
  final Function toogle;
  SignUp(this.toogle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  late String userid;
  inputData() {
    final User? user = auth.currentUser;

    return userid = user!.uid;
    // FirebaseFirestore.instance.collection("users").add("id":uid)

    // here you write the codes to input the data into firestore
  }

  signMeUp() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        return inputData();
      }).then((val) {
        Map<String, String> userInfoMap = {
          "name": userNameTextEditingController.text,
          "email": emailTextEditingController.text,
          "id": userid,
        };

        HelperFunctions.saveUserNameSharedPreference(
            userNameTextEditingController.text);
        HelperFunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);

        databaseMethods.uploadUserInfo(userInfoMap, userid);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return val!.isEmpty || val.length < 2
                              ? "Please Provide Username"
                              : null;
                        },
                        controller: userNameTextEditingController,
                        decoration: InputDecoration(hintText: "username"),
                      ),
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                        controller: emailTextEditingController,
                        decoration: InputDecoration(hintText: "email"),
                      ),
                      TextFormField(
                        validator: (val) {
                          return val!.length > 6 ? null : "gg";
                        },
                        controller: passwordTextEditingController,
                        decoration: InputDecoration(hintText: "password"),
                      ),
                    ],
                  )),
              SizedBox(
                height: 8,
              ),
              Container(child: Text("forgot password?")),
              SizedBox(
                height: 10,
              ),
              RawMaterialButton(
                fillColor: Colors.lightBlue,
                onPressed: () {
                  signMeUp();
                },
                child: Text("Sign Up"),
              ),
              RawMaterialButton(
                fillColor: Colors.lightBlue,
                onPressed: () {},
                child: Text("Sign Up With Google"),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have account?"),
                  GestureDetector(
                    onTap: () {
                      widget.toogle;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Sign in now",
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
