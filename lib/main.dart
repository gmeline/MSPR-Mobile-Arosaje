import 'package:flutter/material.dart';
import 'package:test_arosaje/pages/login_page.dart';
import 'package:test_arosaje/pages/post_creation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'A Rosa Je',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Remplacez LoginPage par le nom de votre page cible
      home: PostCreationScreen(),
    );
  }
}
