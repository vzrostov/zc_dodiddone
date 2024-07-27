import 'package:flutter/material.dart';
import 'package:zc_dodiddone/pages/login_page.dart';
import 'package:zc_dodiddone/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}