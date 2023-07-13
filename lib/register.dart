import 'package:pharmacy_app/utilities/colors.dart';
import 'package:pharmacy_app/utilities/shared_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'data/user.dart';



class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  GlobalKey<FormState> _key = new GlobalKey();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  //bool _validate = false;
  AutovalidateMode _mode = AutovalidateMode.disabled;

  // Firestore _firestore = Firestore.instance;
  late String role;
  late String email, username, password;
  bool _showPassword = true;
  bool _showConfirmPassword = true;
  bool _showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [

                  SizedBox(
                    height: 15,
                  ),
                  buildPngImage('drugs', 90, 90),
                  SizedBox(
                    height: 15,
                  ),
                  registerWithMobile(),
                  SizedBox(height: 10),
                  registerForm(),
                  SizedBox(height: 10),
                  // button(),
                  // SizedBox(height: 20),
                ],
              ),
            )));
  }

  Widget registerWithMobile() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      child: Center(
        child: Text(
          "Sign up",
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }

  Widget registerForm() {
    return Form(
      key: _key,
      child: Container(
          padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
          // decoration: bgDecoration(),
          child: Column(children: [
            TextFormField(
              style: Theme.of(context).textTheme.bodyText2,
              controller: _userNameController,
              decoration: InputDecoration(
                // icon: Icon(Icons.email),
                //border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
                  labelText: 'User name',
                  /* labelStyle: TextStyle(
                    color: ColorConstants.primaryColor,
                  ),*/
                  suffixIcon: Icon(
                    Icons.supervised_user_circle_outlined,
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
                      ))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter user name';
                } else {
                  setState(() {
                    username = value;
                  });
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              style: Theme.of(context).textTheme.bodyText2,
              controller: _userEmailController,
              decoration: InputDecoration(
                // icon: Icon(Icons.email),
                //border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
                labelText: 'Email',
                /* labelStyle: TextStyle(
                    color: ColorConstants.primaryColor,
                  ),*/
                suffixIcon: Icon(
                  Icons.email_rounded,
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
                    username = value;
                  });
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
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
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
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
                /*disabledBorder:UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.disabledColor),
                  ) ,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.accentColor),
                  ),*/
              ),
              obscureText: _showPassword,
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
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              style: Theme.of(context).textTheme.bodyText2,
              decoration: InputDecoration(
                // icon: Icon(Icons.email),
                //border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
                labelText: ' Confirm Password',
                /* labelStyle: TextStyle(
                    color: ColorConstants.primaryColor,
                  ),*/
                suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
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
                /*disabledBorder:UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.disabledColor),
                  ) ,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorConstants.accentColor),
                  ),*/
              ),
              obscureText: _showConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter confirm password';
                }
                if (value != password ) {
                  return 'Confirm password should be same as password';
                }
                else {
                  setState(() {
                    password = value;
                  });
                }
                return null;
              },
            ),
            SizedBox(
              height: 30,
            ),
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
                : button(),
            SizedBox(
              height: 16,
            ),
          ])),
      autovalidateMode: _mode,
    );
  }

  Widget button() {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: ColorConstants.bottomBarColor),
      onPressed: () async {
        if (_key.currentState!.validate()) {
          _showLoading = true;
          Users users = new Users(_userNameController.text,
              _userEmailController.text, _passwordController.text);
          users.userName = _userNameController.text;
          users.password = _passwordController.text;
          users.emailId = _userEmailController.text;
          // users.role = role;

          print("User:" + users.toString());

          //create user collection in the database
          await createUser(users);
          setState(() {});
        }
      },
      child: Text('Register',style: TextStyle(color: ColorConstants.secondary),),
    );
  }

  createUser(Users users) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _userEmailController.text,
          password: _passwordController.text);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        "uid": userCredential.user?.uid,
        "email": users.emailId,
        "username": users.userName
      });
      setState(() {
        _showLoading = false;
      });
      Fluttertoast.showToast(msg: "Registration successfully done");
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.message.toString()}')));
        print('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('Email id already registered');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.message.toString()}')));
      } else {
        print("${e.toString()}");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.message.toString()}')));
      }
      _showLoading = false;
    }
  }

}
