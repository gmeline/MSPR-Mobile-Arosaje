import 'package:flutter/material.dart';
import 'utilisateur.dart';

class AccueilPage extends StatelessWidget {
  final String type;
  AccueilPage({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'accueil'),
      ),
      body: Center(
        child: Text('Bienvenue sur la page d\'accueil madame la $type'),
      ),
    );
  }
}
