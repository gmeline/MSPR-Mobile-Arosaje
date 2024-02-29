import 'package:flutter/material.dart';

class Utilisateur {
  final String mail;
  final String pseudo;
  final String telephone;
  final String motDePasse;
  final String type; // Peut être 'botaniste' ou 'plantowner'

  Utilisateur({
    required this.mail,
    required this.pseudo,
    required this.telephone,
    required this.motDePasse,
    required this.type,
  });
}

List<Utilisateur> listeUtilisateurs = [
  Utilisateur(
    mail: 'melinegodefroy.mg@gmail.com',
    pseudo: 'meline',
    telephone: '0651230854',
    motDePasse: 'mdp1234',
    type: 'botaniste',
  ),
  Utilisateur(
    mail: 'melinegodefroy.pro@gmail.com',
    pseudo: 'mel',
    telephone: '0123456789',
    motDePasse: 'mdp1234',
    type: 'plantowner',
  ),
];
