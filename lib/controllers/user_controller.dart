import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/services/auth_service.dart';
import 'package:go_event_customer/services/firebase_storage_service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

Future<void> editUserData(
    BuildContext context, UserModel userData, File imageFile) async {
  try {
    if (imageFile != null) {
      //upload image to storage
      final storage =
          Provider.of<FirebaseStorageService>(context, listen: false);
      String downloadUrl = await storage.uploadProfilePicture(file: imageFile);
      userData.photoURL = downloadUrl;
    }

    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setUserData(userData);
    if (imageFile != null) await imageFile.delete();
  } catch (e) {
    print(e);
  }
}

Future<void> signUp(
    BuildContext context, UserModel userData, File imageFile) async {
  try {
    //register User, get the UID and save the user data
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final registeredUser = await auth.registerWithEmailAndPassword(
        userData.email, userData.password);

    if (imageFile != null) {
      //upload image to storage
      final storage =
          Provider.of<FirebaseStorageService>(context, listen: false);
      String downloadUrl = await storage.uploadProfilePicture(file: imageFile);
      userData.photoURL = downloadUrl;
    }

    userData.role = "Customer";
    final database = FirestoreService(uid: registeredUser.uid);
    await database.setUserData(userData);
    await imageFile.delete();
  } catch (e) {
    print(e);
  }
}

Future<void> signIn(BuildContext context, String email, String password) async {
  try {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    await auth.signInWithEmailAndPassword(email, password);
  } catch (e) {
    print(e);
  }
}

Future<void> signOut(BuildContext context) async {
  try {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    await auth.signOut();
  } catch (e) {
    print(e);
  }
}
