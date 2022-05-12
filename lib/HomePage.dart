import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late File imageFile;
  late List _results;
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res = (await Tflite.loadModel(
        model: "assets/model/birdclass.tflite",
        labels: "assets/model/labels.txt"))!;
  }

  Future imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      print(_results);
    });
  }

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
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  imageFile = File(image.path);
                  getBottomSheet();
                }
              }),
              child: Text("Fotoğraf Çek"),
            ),
            ElevatedButton(
              onPressed: (() async {
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  imageFile = File(image.path);
                  getBottomSheet();
                }
              }),
              child: Text("Galeriden Seç"),
            ),
          ],
        ),
      ),
    );
  }

  void getBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(child: Image.file(imageFile)),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await imageClassification(imageFile);
                      },
                      child: Text("Türünü Bul"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Kapat"),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
