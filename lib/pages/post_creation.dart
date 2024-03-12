import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:test_arosaje/pages/List_announce.dart';

class PostCreationScreen extends StatefulWidget {
  @override
  _PostCreationScreenState createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  List<File> images = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  Future<void> getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      if (images.length < 1) {
        images.add(imageTemporary);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Limite d'images atteinte"),
              content: Text("Une image à la fois"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  Future<void> selectDate(bool isStartDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = selectedDate;
        } else {
          endDate = selectedDate;
        }
      });
    }
  }

  Widget buildGridView() {
    return images.isEmpty
        ? SizedBox.shrink()
        : GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(images.length, (index) {
        File image = images[index];
        Uint8List imageBytes = image.readAsBytesSync();
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              child: Image.memory(
                Uint8List.fromList(imageBytes),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => removeImage(index),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildDateInfo() {
    String startDateText = startDate != null
        ? "La garde de plante démarre à ${startDate!.toLocal()}."
        : "Sélectionnez une date de début.";

    String endDateText = endDate != null
        ? "Et terminera à ${endDate!.toLocal()}."
        : "Sélectionnez une date de fin.";

    return Column(
      children: [
        Text(
          startDateText,
          style: TextStyle(fontSize: 16.0),
        ),
        Text(
          endDateText,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Future<void> submitForm() async {
    try {
      if (titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          locationController.text.isNotEmpty &&
          startDate != null &&
          endDate != null) {
        Map<String, dynamic> postData = {
          'Titre': titleController.text,
          'Description': descriptionController.text,
          'Localisation': locationController.text,
          'Date_debut': startDate!.toIso8601String(),
          'Date_fin': endDate!.toIso8601String(),
          'Images': images.map((image) {
            return base64Encode(image.readAsBytesSync());
          }).toList(),
        };

        var request = await http.post(
          Uri.parse('http://10.0.2.2:3001/creationAnnonce'),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(postData),
        );

        if (request.statusCode == 200 || request.statusCode == 201) {
          print('Annonce créée avec succès');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListeAnnoncesScreen()),
          );
        } else {
          print(
              'Échec de la création de l\'annonce. Code d\'erreur: ${request.statusCode}');
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Champs incomplets"),
              content: Text(
                  "Veuillez remplir tous les champs avant de soumettre."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Erreur lors de la création de l\'annonce: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Annonce Garde de plante'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text("Prendre une photo"),
                    onPressed: () => getImage(ImageSource.camera),
                  ),
                  ElevatedButton(
                    child: Text("Sélectionner des images"),
                    onPressed: () => getImage(ImageSource.gallery),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              buildGridView(),
              SizedBox(height: 16.0),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Titre de l'annonce",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Description de l'annonce",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Localisation",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              buildDateInfo(),
              SizedBox(height: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => selectDate(true),
                    child: Text("Date de début"),
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () => selectDate(false),
                    child: Text("Date de fin"),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: submitForm,
                child: Text("Soumettre"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PostCreationScreen(),
  ));
}
