// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mychatapp/Home/mainscreen.dart';
import 'package:mychatapp/helper/helper.dart';
import 'package:mychatapp/services/auth.dart';
import 'package:mychatapp/services/database.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final check = GlobalKey<FormState>();
  TextEditingController usernameTextEditer = TextEditingController();
  TextEditingController emailTextEditer = TextEditingController();
  TextEditingController passwordEditer = TextEditingController();
  bool loading = false;
  final AuthMethod authmethod = AuthMethod();
  DataBaseMethods dataBaseMethods = DataBaseMethods();


  InputDecoration textdecoration(String hint) {
    return InputDecoration(
      filled: true,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.green,
        )),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.green,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.green[300],
      ),
      backgroundColor: Colors.green[100],
      body: loading ? const Center(child: CircularProgressIndicator()): Center(
        child: Form(
          key: check,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (val) {return val!.isEmpty ? "Please enter the username" : null;},
                    controller: usernameTextEditer,
                    decoration: textdecoration("Name"),
                  ),
                  TextFormField(
                    validator: (val) {return val!.isEmpty ? "Please enter the email" : null;},
                    controller: emailTextEditer,
                    decoration: textdecoration("Email"),
                  ),
                  TextFormField(
                    validator: (val) {return val!.isEmpty ? "Please enter the password" : null;},
                    controller: passwordEditer,
                    obscureText: true,
                    decoration: textdecoration("Password"),
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    color: Colors.green,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {


                        if(check.currentState!.validate()) {
                          Map<String,String> userMap = {
                            "Name" : usernameTextEditer.text,
                            "email" : emailTextEditer.text,
                          };
                          helpermethod.saveemailloggedinsharedpreference(emailTextEditer.text);
                          helpermethod.saveusernameloggedinsharedpreference(usernameTextEditer.text);
                          setState(() {
                            loading=true;
                          });
                          authmethod.signupwithemailpassword(emailTextEditer.text,passwordEditer.text).then((value) {
                            dataBaseMethods.userinfo(userMap);
                            helpermethod.saveuserloggedinsharedpreference(true);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen() ));
                          });
                        }


                    }, 
                    child: const Text("Sign up",style: TextStyle(color: Colors.black87),),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text("Already Registered? Sign In below"),
                  const SizedBox(height: 20,),
                  Container(
                    color: Colors.green,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.toggle();
                      },
                    child: const Text("Sign In",style: TextStyle(color: Colors.black87),),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: null,
                    child: SizedBox(
                      height: 60,
                      width: 70,
                      child: Image.asset("assets/gicon.png")
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}