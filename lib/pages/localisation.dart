import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'post_creation.dart'; // Importez votre fichier de création de post

class LocalisationScreen extends StatefulWidget {
  const LocalisationScreen({Key? key}) : super(key: key);

  @override
  _LocalisationScreenState createState() => _LocalisationScreenState();
}

class _LocalisationScreenState extends State<LocalisationScreen> {
  TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Localisation de plante',
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 200.0,
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Entrez votre emplacement...',
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Ajoutez votre logique de recherche ici
              // Vous pouvez utiliser _locationController.text pour obtenir la valeur du champ de saisie
              // et utiliser ces informations pour mettre à jour la carte.
            },
          ),
        ],
      ),
      body: content(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajoutez ici le code pour la soumission (naviguer vers la page de création de post)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostCreationScreen()), // Remplacez PostCreationScreen() par votre classe de création de post
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }

  Widget content() {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(46.227638, 2.213749),
        zoom: 5,
        interactionOptions: InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
      ),
      children: [
        openStreetMapTileLayer,
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer {
  return TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleaflet.flutter_map.exemple',
  );
}

void main() {
  runApp(MaterialApp(
    home: LocalisationScreen(),
  ));
}
