import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerApp extends StatefulWidget {
  @override
  _ImagePickerAppState createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  List<File> images = [];

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

  Widget buildGridView() {
    return Expanded(
      child: Center(
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            File image = images[index];
            return Container(
              margin: EdgeInsets.all(8.0),
              child: Image.file(
                image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multiple Picker Image'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildGridView(),
            ElevatedButton(
              child: Text("Sélectionner des images"),
              onPressed: () => getImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImagePickerApp(),
  ));
}
