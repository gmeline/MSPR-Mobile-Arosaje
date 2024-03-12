import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListeAnnoncesScreen extends StatefulWidget {
  @override
  _ListeAnnoncesScreenState createState() => _ListeAnnoncesScreenState();
}

class _ListeAnnoncesScreenState extends State<ListeAnnoncesScreen> {
  List<Map<String, dynamic>> annonces = [];

  @override
  void initState() {
    super.initState();
    fetchAnnonces();
  }

  Future<void> fetchAnnonces() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3001/afficheAnnonce'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('annonces')) {
          final annoncesData = data['annonces'];

          if (annoncesData != null && annoncesData is List) {
            setState(() {
              annonces = List<Map<String, dynamic>>.from(annoncesData);
            });
          } else {
            print('Le champ "annonces" n\'est pas une liste valide.');
          }
        } else {
          print('Le champ "annonces" est absent dans la réponse.');
        }
      } else {
        print('Erreur lors de la récupération des annonces. Code d\'erreur: ${response.statusCode}');
        print('Corps de la réponse : ${response.body}');
      }
    } catch (error) {
      print('Erreur lors de la récupération des annonces: $error');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Annonces'),
        centerTitle: true,
      ),
      body: annonces.isEmpty
          ? Center(child: Text('Aucune annonce disponible.'))
          : ListView.builder(
        itemCount: annonces.length,
        itemBuilder: (context, index) {
          final annonce = annonces[index];
          final photoUrl = annonce['Photo']; // Assurez-vous d'avoir la clé correcte pour l'URL de la photo
          return ListTile(
            title: Text(annonce['Titre']),
            subtitle: Text(annonce['Description']),
            leading: photoUrl != null
                ? Image.network(
              photoUrl,
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            )
                : Container(),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListeAnnoncesScreen(),
  ));
}
