import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final XFile? image;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (() async {
                image = await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {}
              }),
              child: Text("Fotoğraf Çek"),
            ),
            ElevatedButton(
              onPressed: (() async {
                image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {}
              }),
              child: Text("Galeriden Seç"),
            ),
          ],
        ),
      ),
    );
  }
}
