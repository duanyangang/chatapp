import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:last_try/helper/constants.dart';
import 'package:last_try/helper/helperFunctions.dart';
import 'package:last_try/model/database.dart';
import 'package:last_try/services/auth.dart';
import 'package:last_try/widgets/widget.dart';

import 'ChatRoomScreen.dart';

class SignIn extends StatefulWidget {
  // const SignIn({
  //   Key? key,
  // }) : super(key: key);
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

AuthMethods authMethods = new AuthMethods();

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? snapshotUserInfo;

  signMeIn() {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo!.docs[0].data()["name"]);
        // print(snapshotUserInfo!.docs[0].data()["name"]);
        // Constants.myName = snapshotUserInfo!.docs[0].data()["name"];
        // print(Constants.myName);
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
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
                ),
              ),
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
                  signMeIn();
                },
                child: Text("Sign In"),
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
                  Text("Dont have an account?"),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Register now",
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
