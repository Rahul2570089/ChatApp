import 'package:flutter/material.dart';
import 'package:mychatapp/Home/signin.dart';
import 'package:mychatapp/Home/signup.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({ Key? key }) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool signin = true;
  void toggleview() {
    setState(() {
      signin = !signin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return signin ? SignIn(toggleview) : SignUp(toggleview);
  }
}