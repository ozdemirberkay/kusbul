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
  late final File imageFile;
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
                      onPressed: () {},
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

  Future<void> predictFromImage() async {
    String? res = await Tflite.loadModel(
        model: "assets/birdclass.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
  }
}
