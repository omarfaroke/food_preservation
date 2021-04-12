import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<String> uploadFile(String nameFile, File dataFile) async {
    String _uploadedFileURL;

    Reference storageReference = FirebaseStorage.instance.ref().child(nameFile);

    try {
      await storageReference.putFile(dataFile);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
      return null;
    }

    print('File Uploaded');

    _uploadedFileURL = await storageReference.getDownloadURL();

    return _uploadedFileURL;
  }

  static Future<bool> deleteFile(String pathFile) async {
    bool deleteSuccessful = false;

    Reference storageReference = FirebaseStorage.instance.refFromURL(pathFile);

    await storageReference.delete().then((val) {
      deleteSuccessful = true;
      print("deleted file -- $pathFile");
    }).catchError((error) {
      print("error delete File --  $error");
    });

    return deleteSuccessful;
  }
}
