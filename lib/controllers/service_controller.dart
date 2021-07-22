import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/services/firebase_storage_service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

Future<void> setService(
    {@required BuildContext context,
    @required Service service,
    List<File> imageList}) async {
  try {
    if (imageList != null) {
      //upload image to storage
      final storage =
          Provider.of<FirebaseStorageService>(context, listen: false);
      service.images = await storage.uploadServiceImages(
          serviceId: service.serviceId, fileList: imageList);
    }

    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setService(service);
    if (imageList != null)
      imageList.forEach((image) async {
        await image.delete();
      });
  } catch (e) {
    print(e);
  }
}

Future deleteService(BuildContext context, Service service) async {
  final storage = Provider.of<FirebaseStorageService>(context, listen: false);
  final database = Provider.of<FirestoreService>(context, listen: false);
  if (service.images != null) {
    for (var image in service.images) {
      await storage.deleteImage(imageURL: image);
    }
  }
  await database.deleteService(service);
}

Future<File> chooseServiceImage(BuildContext context) async {
  final imagePicker = Provider.of<ImagePickerService>(context, listen: false);
  File imagePicked = await imagePicker.pickImage(source: ImageSource.gallery);
  return imagePicked;
}

Future deleteServiceImage(
    BuildContext context, Service service, int index) async {
  final storage = Provider.of<FirebaseStorageService>(context, listen: false);
  final database = Provider.of<FirestoreService>(context, listen: false);
  await storage.deleteImage(imageURL: service.images[index]);
  service.images.removeAt(index);
  await database.setService(service);
}

Future addServiceImage(
    BuildContext context, Service service, File image) async {
  final storage = Provider.of<FirebaseStorageService>(context, listen: false);
  final database = Provider.of<FirestoreService>(context, listen: false);
  final imageURL = await storage.uploadServiceImage(
      index: service.images.length, file: image, serviceId: service.serviceId);
  service.images.add(imageURL);
  await database.setService(service);
}
