import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/pages/login_page.dart';
import 'package:zc_dodiddone/screens/completed.dart';
import 'package:zc_dodiddone/screens/profile.dart';
import 'package:zc_dodiddone/services/firebase_auth.dart';
import 'package:zc_dodiddone/theme/theme.dart';

import '../pages/main_page.dart';
import '../screens/all_tasks.dart';
import '../screens/today.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authenticationService = AuthService();
  late User? user;

  @override
  void initstate() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    user = _authenticationService.user;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home: 
      user == null? const LoginPage() : const MainPage(),
      
      //initialRoute: '/', // Set the initial route to '/'
      routes: {
        '/login': (context) => LoginPage(), // Define the route for LoginPage
        '/profile': (context) => ProfileScreen(), // Define the route for ProfileScreen
        '/tasks': (context) => TasksPage(), // Define the route for TasksPage
        '/completed': (context) => CompletedPage(), // Define the route for CompletedPage
        '/today': (context) => TodayPage(), // Define the route for TodayPage
      }
    );
  }
}
