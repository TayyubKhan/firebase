import 'dart:io';

import 'package:firebase/Utilis/Utilis.dart';
import 'package:firebase/widgets/RoundedButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImageScreen extends StatefulWidget {
  const AddImageScreen({super.key});

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  File? _image;
  final pick = ImagePicker();
  fstorage.FirebaseStorage storage = fstorage.FirebaseStorage.instance;
  DatabaseReference dB = FirebaseDatabase.instance.ref('Post');
  Future getGalleryImage() async {
    final pickedFile = await pick.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('Image not Picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            'Add Image',
          ),
        ),
        body: Column(
          children: [
            InkWell(
              onTap: () {
                getGalleryImage();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : const Center(child: Icon(Icons.camera_alt)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundedButton(
                title: 'Add',
                onTap: () async {
                  fstorage.Reference ref = fstorage.FirebaseStorage.instance
                      .ref('/Jerry/${DateTime.now().millisecondsSinceEpoch}');
                  fstorage.UploadTask upload = ref.putFile(_image!.absolute);
                  Future.value(upload).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    dB.child('1223').set(
                        {'id': 1, 'image': newUrl.toString()}).then((value) {
                      Utilis().toastMessage('Uploaded');
                    }).onError((error, stackTrace) {
                      Utilis().toastMessage(error.toString());
                    });
                  }).onError((error, stackTrace) {
                    Utilis().toastMessage(error.toString());
                  });
                })
          ],
        ));
  }
}
