import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/pages/login_page.dart';
import 'package:zc_dodiddone/services/firebase_auth.dart';
import 'package:zc_dodiddone/theme/theme.dart';

import '../pages/main_page.dart';

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
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home: 
      user == null? const LoginPage() : const MainPage(),
    );
  }
}
