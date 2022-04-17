import 'package:flutter/material.dart';
import 'package:ghambeel/sharedfolder/loading.dart';
import 'package:ghambeel/modules/login/login.dart';
import 'package:ghambeel/modules/utils.dart';
import 'dart:convert';
import 'package:ghambeel/modules/storage/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ghambeel/modules/homepage/homepage.dart';
// import 'package:mysql1/mysql1.dart';
// import 'package:ghambeel/modules/utils.dart';
import 'package:crypto/crypto.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool loading = false;
  var email = TextEditingController();
  var password = TextEditingController();
  var username = TextEditingController();
  String serverUrl = 'http://74.207.234.113:8080';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //var db = Mysql();

  // void getName(name) {
  //   db.getConnection().then((connection) {
  //     String sql = 'select * from ghambeel.Users;';
  //     connection.query(sql).then((results) => {
  //       print(results)
  //     });
  //     connection.close();
  //   });
  // }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    email.dispose();
    password.dispose();
    username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color.fromRGBO(197, 244, 250, 1), Color.fromRGBO(255, 223, 126, 1)]
          )
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Sign up Page"),
          backgroundColor: Color(0xff00bcd4),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(padding: EdgeInsets.only(top: 20)),
              const Image(
                image: AssetImage("assets/images/logo.png"),
                height: 200,
                width: 200,
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.password),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      labelText: 'Username',
                      hintText: 'Enter a unique username'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.password),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.5),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                        new SnackBar(duration: new Duration(seconds: 4), content:
                        new Row(
                          children: <Widget>[
                              new CircularProgressIndicator(),
                              new Text("  Signing-In...")
                            ],
                          ),
                        )
                    );
                    var newEmail = email.text;
                    var newUsername = username.text;
                    var newPassword = password.text;
                    var data = jsonEncode({
                      "email" : newEmail,
                      "username" : newUsername,
                      "password": sha256.convert(utf8.encode(newPassword)).toString()
                    });
                    postData(data, "Users", serverUrl);
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('log', true);
                    prefs.setString('username', newUsername);
                    setState(() => {
                      loading = true
                    });
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const MyHomePage(
                            title: "FLutter")));
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                  child: const Text(
                      "Existing user? Sign in!",
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}