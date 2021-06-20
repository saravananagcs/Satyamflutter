import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../product/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/home.dart';
import 'package:http/http.dart' as http;

import 'Background.dart';

//var initScreen;
//
//Future<void> main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  SharedPreferences preferences = await SharedPreferences.getInstance();
//  initScreen = await preferences.getInt('initScreen');
//  await preferences.setInt('initScreen', 1);
//  runApp(MaterialApp(home: LoginUser()));
//}
//
//class LoginUser extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      initialRoute: initScreen == 0 || initScreen == null ? 'onboard' : 'home',
//      routes: {
//        'home': (context) => LoginUser(),
//        'onboard': (context) => OnboardingScreenOne(),
//      },
//    );
//  }

//}

class LoginUser extends StatefulWidget {
  LoginUserState createState() => LoginUserState();
}

class LoginUserState extends State {
  // For CircularProgressIndicator.
  bool visible = false;



  // Getting value from TextField widget.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  Future userLogin() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String email = emailController.text;
    String password = passwordController.text;

    // SERVER LOGIN API URL
    var url = 'https://www.mireport.in/sms_mobile/satyam_flutter_login.php';

    // Store all data with Param Name.
    var data = {'email': email, 'password': password};

    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);

    // If the Response Message is Matched.
    if (message == 'Invalid user name & password') {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('loggin_value', "No");

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      prefs.setBool("isLoggedIn", true);
//      prefs.setString("username", emailController.text.toString());
//      prefs.setString("userid", message.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', emailController.text.toString());
      prefs.setString('userid', message.toString());
      prefs.setString('loggin_value', "Yes");

      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileScreen(
                  emailController.text.toString(), message.toString())));
    }
  }
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    checkloginstate();
//  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
      return
        Scaffold(
          body: Background(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: emailController,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    autocorrect: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: RaisedButton(
                    onPressed: () {
                      userLogin();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: size.width * 0.5,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: new LinearGradient(colors: [
                            Color.fromARGB(255, 255, 136, 34),
                            Color.fromARGB(255, 255, 177, 41)
                          ])),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "LOGIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: GestureDetector(
                    onTap: () =>
                    {
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()))
                    },
                    child: Text(
                      "Don't Have an Account? Sign up",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
    }
  }

