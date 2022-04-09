import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ghambeel/modules/homepage/homepage.dart';
import 'package:ghambeel/sharedfolder/loading.dart';
import 'package:ghambeel/theme.dart';
import 'signup.dart';
import 'package:ghambeel/modules/login/signup.dart';
import 'package:ghambeel/modules/utils.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ghambeel/modules/storage/storage.dart';

class ChangePage extends StatefulWidget {
  const ChangePage({Key? key}) : super(key: key);

  @override
  _ChangePageState createState() => _ChangePageState();
}

class _ChangePageState extends State<ChangePage> {
  final formkey = GlobalKey<FormState>();
  final pass = TextEditingController();
  final confirmpass = TextEditingController();

  @override
  void dispose() {
    pass.dispose();
    confirmpass.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg[darkMode],
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: primary[darkMode],
      ),
      body: Form(
        key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: pass,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: confirmpass,
                validator: (value) {
                  if (value != null && value != pass.text) {
                    return 'Passwords do not match!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  if (formkey.currentState!.validate()) {
                    var password = pass.text;
                    changePass(password);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Change Password',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}