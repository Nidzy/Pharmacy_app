import 'package:pharmacy_app/register.dart';
import 'package:pharmacy_app/user_home.dart';
import 'package:pharmacy_app/utilities/colors.dart';
import 'package:pharmacy_app/utilities/shared_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_home.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  GlobalKey<FormState> _key = new GlobalKey();
  final _userEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _validate = false;
  bool _passwordVisible = true;
  bool _showLoading = false;
  late String email, password;

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoggedin = false;
  late SharedPreferences preferences;

  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete(() {
      setState(() {
        checkLogin();
      });
    });
  }

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  checkLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedin = false;
        print('User is logged out!');
      } else {
        print('User is logged in!');
        isLoggedin = true;

        setState(() {
          //check which user is logged in based on email
          if (this.preferences?.getString("userEmail") != null) {
            print("inside pref check");
            var email = this.preferences?.getString("userEmail");
            print(email.toString());

            String userName = email!.substring(0, email.indexOf('@'));
            print(userName);

            if (userName.contains("admin")) {
              //Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  //builder: (context) => Register(),
                  builder: (context) => AdminHome(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  // builder: (context) => Register(),
                  builder: (context) => UserHome(),
                ),
              );
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Library Loans")),
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      buildPngImage('drugstore', 70, 70),
                      loginTitle(),
                      SizedBox(height: 10),
                      loginForm(),
                      SizedBox(height: 10),
                      _showLoading
                          ? Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      )
                          : button(context),
                      SizedBox(height: 20),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                                // builder: (context) => AddBook(),
                              ),
                            );
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "Don't have account? ",
                                  style: TextStyle(color: Colors.black87)),
                              TextSpan(
                                  text: "Sign up here",
                                  style: TextStyle(
                                      color: Colors.indigoAccent,
                                      fontWeight: FontWeight.bold)),
                            ]),
                          )),
                    ],
                  ),
                ))));
  }

  Widget loginTitle() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      child: Center(
        child: Text(
          "Smart Pharmacy",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
        key: _key,
        child: Container(
            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
            // decoration: bgDecoration(),
            child: Column(children: [
              TextFormField(
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  // icon: Icon(Icons.email),
                  //border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
                  labelText: 'Email',
                  /* labelStyle: TextStyle(
                    color: ColorConstants.primaryColor,
                  ),*/
                  suffixIcon: Icon(
                    Icons.email,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(
                          color: ColorConstants.primaryColor, width: 1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(width: 1)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorConstants.primaryColor, width: 1),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      )),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  } else {
                    setState(() {
                      email = value;
                    });
                  }
                  return null;
                },
                onChanged: (value) {
                  // this.username = value;
                },
                maxLines: 1,
                controller: _userEmailController,
                // validator: validateField,
              ),
              SizedBox(height: 10),
              TextFormField(
                style: Theme.of(context).textTheme.bodyText2,
                decoration: InputDecoration(
                  // icon: Icon(Icons.email),
                  //border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
                  labelText: 'Password',
                  /* labelStyle: TextStyle(
                    color: ColorConstants.primaryColor,
                  ),*/
                  suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      }),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(
                          color: ColorConstants.primaryColor, width: 1)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(width: 1)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorConstants.primaryColor, width: 1),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      )),
                ),

                obscureText: _passwordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  } else {
                    setState(() {
                      password = value;
                    });
                  }
                  return null;
                },
                onChanged: (value) {
                  // this.username = value;
                },
                maxLines: 1,
                controller: _passwordController,
                // validator: validateField,
              ),
            ])));
  }

  Widget button(BuildContext context) {
    return TextButton(
      style:
      TextButton.styleFrom(backgroundColor: ColorConstants.bottomBarColor),
      onPressed: () async {
        if (_key.currentState!.validate()) {
          _showLoading = true;
          await doLogin(email, password);
          setState(() {});
        }
      },
      child: Text('Login', style: TextStyle(color: ColorConstants.secondary)),
    );
  }

  doLogin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _showLoading = false;
      //Navigator.of(context).pop();
      this.preferences?.setString("userEmail", email);
      if (userCredential.user!.email!.contains("admin")) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            //builder: (context) => Register(),
            builder: (context) => AdminHome(),
          ),
        );
      }  if (userCredential.user!.email!.contains("demo")){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserHome(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('This user is not registered');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorConstants.accentColor,
            content: Text('This user is not registered',
                style: TextStyle(color: ColorConstants.buttonTextColor))));
      } else if (e.code == 'wrong-password') {
        print('incorrect password ');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorConstants.accentColor,
            content: Text(
              'incorrect password',
              style: TextStyle(color: ColorConstants.buttonTextColor),
            )));
      } else {
        print("${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: ColorConstants.accentColor,
            content: Text('${e.message.toString()}',
                style: TextStyle(color: ColorConstants.buttonTextColor))));
      }
      _showLoading = false;
    }

    @override
    void dispose() {
      super.dispose();
    }
  }
}
