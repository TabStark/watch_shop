import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';
import 'package:watch_shop/popup%20and%20loader/dialogs.dart';
import 'package:watch_shop/screens/home_screen.dart';

import 'package:watch_shop/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // Loading Animation
  late final AnimationController _controller =
      AnimationController(duration: Duration(seconds: 3), vsync: this)
        ..repeat();

  // To show Password
  bool show_password = true;

  // TextEditing controller
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColor().black),
        child: Center(
          child: Container(
            height: mq.height * .45,
            width: mq.width * .9,
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
            decoration: BoxDecoration(
                color: AppColor().grey,
                border: Border.all(color: AppColor().black),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            child: Column(
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 23, color: AppColor().white),
                ),

                // Email text field
                SizedBox(
                  height: mq.height * 0.03,
                ),
                TextFormField(
                  controller: _email,
                  style: TextStyle(color: AppColor().white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      label: const Text('Email'),
                      labelStyle: TextStyle(color: AppColor().white),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: AppColor().white, width: 1.2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: AppColor().white, width: 1.5))),
                ),

                // Password text field
                SizedBox(
                  height: mq.height * 0.02,
                ),
                TextFormField(
                  controller: _password,
                  style: TextStyle(color: AppColor().white),
                  obscureText: show_password,
                  decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            show_password = !show_password;
                          });
                        },
                        child: Icon(
                          show_password
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColor().white,
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      label: const Text('Password'),
                      labelStyle: TextStyle(color: AppColor().white),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: AppColor().white, width: 1.2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          borderSide:
                              BorderSide(color: AppColor().white, width: 1.5))),
                ),

                // Buttons
                SizedBox(
                  height: mq.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        height: mq.height * 0.05,
                        width: mq.width * 0.3,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor().white),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            },
                            child: Text(
                              "signup",
                              style: TextStyle(color: AppColor().black),
                            ))),
                    SizedBox(
                        height: mq.height * 0.05,
                        width: mq.width * 0.3,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor().yellow),
                            onPressed: () {
                              _signinViaEmail();
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: AppColor().black),
                            )))
                  ],
                ),

                SizedBox(
                  height: mq.height * 0.02,
                ),
                Divider(),
                Text(
                  "or",
                  style: TextStyle(color: AppColor().white),
                ),

                // Sign in with google
                SizedBox(
                  height: mq.height * 0.02,
                ),
                SizedBox(
                  height: mq.height * .05,
                  width: mq.width * .8,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor().white),
                      onPressed: () {
                        _handleGoogleSignin();
                      },
                      icon: Image.asset(
                        'assets/images/googleLogo.png',
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      label: Text(
                        'Sign in with google',
                        style: TextStyle(color: AppColor().black),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Sign in with Email Function
  _signinViaEmail() {
    if (_email.text == "" || _password.text == "") {
      DialogsWidget.showFlushBar(context, 'Please enter all the fields');
    } else if (!_email.text.contains('@')) {
      DialogsWidget.showFlushBar(context, 'Invalid email');
    } else {
      DialogsWidget.showProgressBar(context, _controller);
      Apis().signInWithEmail(context, _email.text, _password.text);
    }
  }

  // Sign in with Google Function
  _handleGoogleSignin() {
    DialogsWidget.showProgressBar(context, _controller);
    Apis().signInWithGoogle(context).then((user) async {
      Navigator.pop(context);
      if (user != null) {
        if (await Apis.userExists()) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          await Apis.createUser().then((value) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          });
        }
      }
    });
  }
}
