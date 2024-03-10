import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'localisation.dart'; // Import the LocalisationScreen

class PostCreationScreen extends StatefulWidget {
  @override
  _PostCreationScreenState createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  List<File> images = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      if (images.length < 6) {
        images.add(imageTemporary);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Limite d'images atteinte"),
              content: Text("Vous ne pouvez sélectionner que 6 images."),
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
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              child: Image.file(
                image,
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
        Text(startDateText),
        Text(endDateText),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Garde de plante'),
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
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Description de l'annonce",
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
                  ElevatedButton(
                    onPressed: () => selectDate(false),
                    child: Text("Date de fin"),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Vérifiez si tous les champs sont remplis
                  if (images.isNotEmpty &&
                      titleController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      startDate != null &&
                      endDate != null) {
                    // Si tous les champs sont remplis, naviguez vers la page de localisation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocalisationScreen()),
                    );
                  } else {
                    // Sinon, affichez un message d'erreur
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
                },
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
