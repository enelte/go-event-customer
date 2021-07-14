import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'firestore_path.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  FirebaseStorageService({@required this.uid}) : assert(uid != null);
  final String uid;

  /// Upload an avatar from file
  Future<String> uploadProfilePicture({
    @required File file,
  }) async =>
      await upload(
        file: file,
        path: FirestorePath.userData(uid) + '/profile_picture.png',
      );

  Future<String> uploadServiceImage({
    @required File file,
    @required String serviceId,
    @required int index,
  }) async =>
      await upload(
          file: file,
          path: FirestorePath.service(uid) +
              '/$serviceId/${basename(file.path)}');

  Future<String> uploadProofOfPayment({
    @required File file,
    @required String transactionId,
    @required String proofOfPaymentId,
  }) async =>
      await upload(
          file: file,
          path: FirestorePath.proofOfPayment(transactionId, proofOfPaymentId) +
              '${basename(file.path)}');

  Future<List<String>> uploadServiceImages({
    @required List<File> fileList,
    @required String serviceId,
  }) async {
    List<String> pictureURLs = [];
    for (var file in fileList) {
      pictureURLs.add(await upload(
        file: file,
        path: FirestorePath.service(uid) + '/$serviceId/${basename(file.path)}',
      ));
    }
    return pictureURLs;
  }

  /// Generic file upload for any [path]
  Future<String> upload({
    @required File file,
    @required String path,
  }) async {
    try {
      print('uploading to: $path');
      Reference storageReference = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      // Url used to download file/image
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('downloadUrl: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      return "Error occurred on file upload" + e.toString();
    }
  }

  Future deleteImage({@required String imageURL}) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.refFromURL(imageURL);
      await storageReference.delete();
      print(storageReference.fullPath + 'successfully deleted');
    } catch (e) {
      print("Error occurred on file upload" + e.toString());
    }
  }
}
