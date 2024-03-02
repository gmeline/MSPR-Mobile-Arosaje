import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class ImagePickerApp extends StatefulWidget {
  const ImagePickerApp({Key? key}) : super(key: key);

  @override
  _ImagePickerAppState createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  File? _image;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source:  ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      this._image = imageTemporary;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick an image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://www.ikea.com/fr/fr/images/products/fejka-plante-artificielle-en-pot-interieur-exterieur-monstera__0614197_pe686822_s5.jpg?f=xl',
              height: 150,
            ),
            SizedBox(height: 20),
            PhotoButton(
              title: 'Pick an Image',
              icon: Icons.image_outlined,
              onClick: () {
                // Add logic for picking an image
              },
            ),
            SizedBox(height: 20),
            PhotoButton(
              title: "Take a Photo",
              icon: Icons.camera,
              onClick: () {
                // Add logic for taking a photo
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onClick;

  const PhotoButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      child: ElevatedButton(
        onPressed: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(width: 20),
            Text(title),
          ],
        ),
      ),
    );
  }
}
