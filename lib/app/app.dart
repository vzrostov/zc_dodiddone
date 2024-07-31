import 'package:flutter/material.dart';
import 'package:zc_dodiddone/pages/login_page.dart';
import 'package:zc_dodiddone/theme/theme.dart';

//import '../pages/main_page.dart';
import '../screens/profile.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home: const LoginPage(),
      //home: const MainPage(),
      // Define the routes
      // initialRoute: '/', // Set the initial route to '/'
      // routes: {
      //   '/': (context) => LoginPage(), // Replace with your initial screen
      //   '/login': (context) => LoginPage(), // Define the '/login' route
      // },
    );
  }
}
