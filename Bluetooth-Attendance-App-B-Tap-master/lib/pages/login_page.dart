// ignore_for_file: unused_import, avoid_print, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth.dart';
import 'package:att_blue/pages/staff_home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? errorMsg = '';

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  Widget _entryField(String title, TextEditingController controller) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          controller: controller,
          obscureText: title == 'Password' ? true : false,
          decoration: InputDecoration(
            labelText: title,
            border: const OutlineInputBorder(),
          ),
        ));
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return errorMsg == '' ? const SizedBox() : Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(errorMsg!, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _loginBtn() {
    return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
            onPressed: () async {
              var email = _emailCtrl.text.trim();
              var password = _passwordCtrl.text.trim();
              User? firebaseUser = FirebaseAuth.instance.currentUser;
              if (!email.toLowerCase().endsWith('tce.edu')) {
                setState(() {
                  errorMsg = 'Not a valid Email';
                });
              } else if (email != "" && password != "") {
                try {
                  firebaseUser = await (await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password))
                      .user;

                  if (firebaseUser != null) {
                    print(firebaseUser);
                    if (email.toLowerCase().endsWith('@student.tce.edu')) {
                      Get.offNamed('/studentHome');
                    } else {
                      Get.offNamed('/staffHome');
                    }
                  } else {
                    print("USER IS NULL!");
                  }
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    errorMsg = e.message;
                  });
                }
              } else {
                setState(() {
                  errorMsg = 'Email and Password mismatch';
                });
              }
            },
            child: const Text('Login')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome back!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                _entryField('Email', _emailCtrl),
                const SizedBox(height: 10),
                _entryField('Password', _passwordCtrl),
                const SizedBox(height: 10),
                _errorMessage(),
                const SizedBox(height: 20),
                _loginBtn(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Create an account?'),
                    TextButton(
                      onPressed: () {
                        Get.offNamed('/register');
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
