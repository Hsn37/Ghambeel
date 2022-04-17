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
// import 'package:mysql1/mysql1.dart';
// import 'package:ghambeel/modules/utils.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  var username = TextEditingController();
  var password = TextEditingController();

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

  Future<bool> loggedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final status = await prefs.getBool('log') ?? false;
    return status;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    username.dispose();
    password.dispose();
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
      child: FutureBuilder(
        future: loggedStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return const MyHomePage(title: 'Calendar');
            }
            else {
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text("Login Page"),
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
                          controller: username,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.account_circle),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.5),
                              labelText: 'username',
                              hintText: 'Enter valid username'),
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
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          onPressed: () async {
                            var success = await getData("http://74.207.234.113:8080/?username="+username.text + "&password=" + password.text);

                            if (success['status'] == 'true') {
                              // redo after validation
                              final prefs = await SharedPreferences.getInstance();
                              prefs.setBool('log', true);
                              prefs.setString('username', username.text);
                              await Storage.recoverTasks();
                              setState(() => {
                                loading = true
                              });
                              await Future.delayed(const Duration(seconds: 2));
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const MyHomePage(
                                      title: "FLutter")));
                              // loading = false;
                            }
                            else {
                              bool status = await alertDialog("Incorrect Password", "Try again.", context);
                            }
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                          },
                          child: const Text(
                              "New User? Sign up!"
                          )
                      )
                  ]),
                ),
              );
            }
          }
          else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}