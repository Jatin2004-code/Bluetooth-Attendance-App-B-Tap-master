// ignore_for_file: avoid_print, unused_import

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? errorMsg = '';
  String? _selectedRole = 'Student'; // Default to Student

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  final TextEditingController _regNoCtrl = TextEditingController();
  //Dropdown for Semester
  String? _selectedSemester;
  final List<String> _semester = [
    'Semester',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8'
  ];
  //Dropdown for Slot
  String? _selectedSlot;
  final List<String> _slot = ['Slot', 'A', 'B', 'C'];

  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _emailCtrl.text.trim(), password: _passwordCtrl.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message;
      });
    }
  }

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

  //Widget for Dropdown for Semester
  Widget _semesterDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          labelText: 'Semester',
          border: OutlineInputBorder(),
        ),
        value: _selectedSemester,
        items: _semester.map((semester) {
          return DropdownMenuItem(
            value: semester,
            child: Text(semester),
          );
        }).toList(),
        onChanged: (value) {
          if (value.toString() != 'Semester') {
            setState(() {
              _selectedSemester = value.toString();
            });
          }
        },
      ),
    );
  }

  //Widget for Dropdown for Slot
  Widget _slotDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          labelText: 'Slot',
          border: OutlineInputBorder(),
        ),
        value: _selectedSlot,
        items: _slot.map((slot) {
          return DropdownMenuItem(
            value: slot,
            child: Text(slot),
          );
        }).toList(),
        onChanged: (value) {
          if (value.toString() != 'Slot') {
            setState(() {
              _selectedSlot = value.toString();
            });
          }
        },
      ),
    );
  }

  // Widget for Role Selection
  Widget _roleSelection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Text('Role: '),
          Radio<String>(
            value: 'Student',
            groupValue: _selectedRole,
            onChanged: (value) {
              setState(() {
                _selectedRole = value;
              });
            },
          ),
          const Text('Student'),
          Radio<String>(
            value: 'Teacher',
            groupValue: _selectedRole,
            onChanged: (value) {
              setState(() {
                _selectedRole = value;
              });
            },
          ),
          const Text('Teacher'),
        ],
      ),
    );
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

  //Widget to show snackbar with a parameter of String
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Widget _registerBtn() {
    return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () async {
            var name = _nameCtrl.text.trim();
            var email = _emailCtrl.text.trim();
            var regno = _regNoCtrl.text.trim();
            var password = _passwordCtrl.text.trim();
            var confirmPassword = _confirmPasswordCtrl.text.trim();
            // var semester = _selectedSemester;
            // var slot = _selectedSlot;

            if (name == '' ||
                email == '' ||
                (_selectedRole == 'Student' ? regno == '' : false) ||
                password == '' ||
                confirmPassword == '' ||
                (_selectedRole == 'Student' ? _selectedSemester == null : false) ||
                (_selectedRole == 'Student' ? _selectedSlot == null : false)) {
              _showSnackBar('Please fill all the fields');
            } else if (password != confirmPassword) {
              _showSnackBar('Passwords don\'t match');
            } else if (_selectedRole == 'Student' && !email.toLowerCase().endsWith('@student.tce.edu')) {
              _showSnackBar('Not a valid Student Email');
            } else if (_selectedRole == 'Teacher' && (!email.toLowerCase().endsWith('@tce.edu') || email.toLowerCase().endsWith('@student.tce.edu'))) {
              _showSnackBar('Not a valid Teacher Email');
            } else {
                try {
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password)
                      .then((value) async {
                            _showSnackBar("Created");
                            DocumentReference<Map<String, dynamic>> db;
                            DocumentSnapshot<Map<String, dynamic>> data;
                            if (_selectedRole == 'Student') {
                              db = await FirebaseFirestore.instance
                                  .collection("Student")
                                  .doc(
                                      "Semester $_selectedSemester Slot $_selectedSlot");
                              data = await db.get();
                              if (!data.exists) {
                                db.set({
                                  "Students": FieldValue.arrayUnion([
                                    {
                                      "Name": name,
                                      "Register number": regno,
                                      "Email": email,
                                    }
                                  ])
                                });
                              } else {
                                db.update({
                                  "Students": FieldValue.arrayUnion([
                                    {
                                      "Name": name,
                                      "Register number": regno,
                                      "Email": email,
                                    }
                                  ])
                                });
                              }
                              _showSnackBar("Added to Database");
                              Get.offNamed('/studentHome');
                            } else if (_selectedRole == 'Teacher') {
                              db = await FirebaseFirestore.instance
                                  .collection("Teacher")
                                  .doc("Teachers");
                              data = await db.get();
                              if (!data.exists) {
                                db.set({
                                  "Teachers": FieldValue.arrayUnion([
                                    {
                                      "Name": name,
                                      "Email": email,
                                    }
                                  ])
                                });
                              } else {
                                db.update({
                                  "Teachers": FieldValue.arrayUnion([
                                    {
                                      "Name": name,
                                      "Email": email,
                                    }
                                  ])
                                });
                              }
                              _showSnackBar("Added to Database");
                              Get.offNamed('/staffHome');
                            }
                          });
              } on FirebaseAuthException catch (e) {
                print(e.code);
                String? err = e.message;
                _showSnackBar(err!);
              }
            }
          },
          child: const Text('Register'),
        ));
  }

  //Fix the bottom overflowed by 54 pixels

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Create an account',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  _roleSelection(),
                  _entryField('Name', _nameCtrl),
                  _entryField('Email', _emailCtrl),
                  if (_selectedRole == 'Student') _entryField('Register Number', _regNoCtrl),
                  if (_selectedRole == 'Student') _semesterDropdown(),
                  if (_selectedRole == 'Student') _slotDropdown(),
                  _entryField('Password', _passwordCtrl),
                  _entryField('Confirm Password', _confirmPasswordCtrl),
                  _errorMessage(),
                  const SizedBox(height: 20),
                  _registerBtn(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Get.offNamed('/login');
                        },
                        child: const Text('Login'),
                      ),
                    ],
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
