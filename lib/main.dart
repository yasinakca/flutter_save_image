import 'dart:io';
import 'package:flutter/material.dart';
import 'package:save_image/model/image.dart';
import 'package:save_image/service/database_helper.dart';
import 'utility.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<File> imageFile;
  Image image;
  DatabaseHelper dbHelper;
  List<Photo> images;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = [];
    dbHelper = DatabaseHelper();
    refreshImages();
  }

  refreshImages() {
    dbHelper.getPhotos().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });
  }

  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Utility.base64String(imgFile.readAsBytesSync());
      Photo photo = Photo(id: 0, photoName: imgString);
      dbHelper.save(photo);
      refreshImages();
    });
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images.map((photo) {
          return Utility.imageFromBase64String(photo.photoName);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swflite Save Image'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: pickImageFromGallery,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: gridView(),
            ),
          ],
        ),
      ),
    );
  }
}
