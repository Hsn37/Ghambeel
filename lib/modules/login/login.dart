import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ghambeel/modules/homepage/homepage.dart';
import 'package:ghambeel/sharedfolder/loading.dart';
import 'package:ghambeel/theme.dart';
import 'signup.dart';
import 'package:ghambeel/modules/login/signup.dart';
import 'package:http/http.dart';
import 'dart:convert';
// import 'package:mysql1/mysql1.dart';
// import 'package:ghambeel/modules/utils.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;
  var email = TextEditingController();
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

  Future<Map> getData(email, pwd) async {
    // Replace the url inside with https://localhost:{port}/?username=admin&password=123 (try either localhost or 10.0.0.2)
    Response response = await get(Uri.parse("http://10.0.2.2:8080/?username="+email + "&password=" + pwd));
    Map data = jsonDecode(response.body);
    return data;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    email.dispose();
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
      child: Scaffold(
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
              TextButton(
                onPressed: (){
                  print(":)");
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                    var success = await getData(email.text, password.text);
                    if (success['status'] == 'true') {
                      // redo after validation 
                      setState(() => {
                        loading = true
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const MyHomePage(
                              title: "FLutter")));
                          // loading = false;
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
            ],
          ),
        ),
      ),
    );
  }
}



class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}