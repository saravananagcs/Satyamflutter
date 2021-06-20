import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'onboarding/screen_one.dart';
import 'product/product.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/home.dart';
import 'login/login.dart';

var initScreen;
var status;
var username;
var userid;
String email, id, loginstate;

Future<void> main() async {
  SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt('initScreen');
  await prefs.setInt('initScreen', 1);
  email = prefs.getString('username');
  id = prefs.getString('userid');
  loginstate = prefs.getString('loggin_value');
//  navigateUser();
  runApp(MaterialApp(home:
//  SplashScreen(
//      backgroundColor: Colors.blue[400],
//      image: Image.asset('images/pngegg.png'),
//      seconds: 5,
//      title: Text(
//        'Pappier',
//        style: TextStyle(color: Colors.white, fontSize: 30),
//      ),
//      navigateAfterSeconds:
      loginstate == 'Yes' ? ProfileScreen(email,id) : MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xFF2661FA),
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute:
              initScreen == 0 || initScreen == null ? 'onboard' : 'home',
          routes: {
            'home': (context) => LoginUser(),
            'onboard': (context) => OnboardingScreenOne(),
          },
        );
      }
}
