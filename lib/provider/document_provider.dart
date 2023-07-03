import 'dart:io';

import 'package:doc_saver_app/helper/snackbar_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DocumentProvider extends ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String _selectedFileName = "";
  String get selectedFileName => _selectedFileName;
  File? _file;
  final FirebaseDatabase _firebaseDatabase =
      FirebaseDatabase.instance; // To upload data to firebase database!
  final FirebaseStorage _firebaseStorage =
      FirebaseStorage.instance; // To upload data to firebase storage!
  setSelectedFileName(String value) {
    _selectedFileName = value;
    notifyListeners();
  }

  pickDocument(BuildContext context) async {
    await FilePicker.platform
        .pickFiles(
      allowMultiple: false,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      type: FileType.custom,
    )
        .then(
      (result) {
        if (result != null) {
          PlatformFile selectedFile = result.files.first;
          setSelectedFileName(selectedFile.name);
          _file = File(selectedFile.path!);
        } else {
          SnackbarHelper.showErrorSnackbar(context, 'No file selected!');
        }
      },
    );
  }

  bool _isFileUploading = false;
  bool get isFileUploading => _isFileUploading;

  setIsFileUploading(bool value) {
    _isFileUploading = value;
    notifyListeners();
  }

  resetAll() {
    titleController = TextEditingController();
    noteController = TextEditingController();
    _selectedFileName = '';
    _file = null;
  }

  String userId = FirebaseAuth.instance.currentUser!.uid;

  sendDocumentData({required BuildContext context}) async {
    try {
      setIsFileUploading(true);

      // Uploading files to Firebase Storage!

      UploadTask uploadTask = _firebaseStorage
          .ref()
          .child('files/$userId')
          .child(_selectedFileName)
          .putFile(_file!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String uploadedFileUrl = await taskSnapshot.ref.getDownloadURL();

      // Uploading files to firebase database!

      await _firebaseDatabase.ref().child("files_info/$userId").push().set({
        "title": titleController.text,
        "note": noteController.text,
        "fileUrl": uploadedFileUrl,
        "date": DateTime.now().toString(),
        "fileName": _selectedFileName,
        "fileType": _selectedFileName.split('.').last
      }).then((value) {
        SnackbarHelper.showSuccessSnackbar(context, "Uploaded Successfully!");
      });
      resetAll();
      setIsFileUploading(false);
    } on FirebaseException catch (error) {
      setIsFileUploading(false);
      SnackbarHelper.showErrorSnackbar(context, error.message!);
    } catch (err) {
      setIsFileUploading(false);
      SnackbarHelper.showErrorSnackbar(context, err.toString());
    }
  }

  Future<void> deleteDocument(
      String id, String fileName, BuildContext context) async {
    try {
      await _firebaseStorage.ref().child('files/$userId/$fileName').delete();
      await _firebaseDatabase
          .ref()
          .child('files_info/$userId/$id')
          .remove()
          .then((value) {
        SnackbarHelper.showSuccessSnackbar(context, 'Deleted Successfully!');
      });
    } on FirebaseException catch (error) {
      SnackbarHelper.showErrorSnackbar(context, error.message!);
    } catch (err) {
      SnackbarHelper.showErrorSnackbar(context, err.toString());
    }
  }
}
