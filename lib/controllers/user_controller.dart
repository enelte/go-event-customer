import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/services/auth_service.dart';
import 'package:go_event_customer/services/firebase_storage_service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

Future<void> editUserData(
    {@required BuildContext context,
    @required UserModel userData,
    @required File profilePicture,
    File idCard,
    File selfieWithIdCard}) async {
  try {
    if (profilePicture != null) {
      //upload image to storage
      final storage =
          Provider.of<FirebaseStorageService>(context, listen: false);
      String downloadUrl =
          await storage.uploadProfilePicture(file: profilePicture);
      userData.photoURL = downloadUrl;
    }

    if (idCard != null) {
      //upload image to storage
      final storage =
          Provider.of<FirebaseStorageService>(context, listen: false);
      String downloadUrl = await storage.uploadIdCard(file: idCard);
      userData.idCardURL = downloadUrl;
      await idCard.delete();
    }
    if (selfieWithIdCard != null) {
      //upload image to storage
      final storage =
          Provider.of<FirebaseStorageService>(context, listen: false);
      String downloadUrl =
          await storage.uploadProfilePicture(file: selfieWithIdCard);
      userData.selfieWithIdCardURL = downloadUrl;
      await selfieWithIdCard.delete();
    }

    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setUserData(userData);
    if (profilePicture != null) await profilePicture.delete();
  } catch (e) {
    print(e);
  }
}

Future<String> signUp(
    {@required BuildContext context,
    @required UserModel userData,
    @required File profilePicture,
    File idCard,
    File selfieWithIdCard}) async {
  try {
    //register User, get the UID and save the user data
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final registeredUser = await auth.registerWithEmailAndPassword(
        userData.email, userData.password);
    if (registeredUser is String) return registeredUser;

    if (profilePicture != null) {
      //upload image to storage
      final storage = FirebaseStorageService(uid: registeredUser.uid);
      String downloadUrl =
          await storage.uploadProfilePicture(file: profilePicture);
      userData.photoURL = downloadUrl;
      await profilePicture.delete();
    }
    if (idCard != null) {
      //upload image to storage
      final storage = FirebaseStorageService(uid: registeredUser.uid);
      String downloadUrl = await storage.uploadIdCard(file: idCard);
      userData.idCardURL = downloadUrl;
      await idCard.delete();
    }
    if (selfieWithIdCard != null) {
      //upload image to storage
      final storage = FirebaseStorageService(uid: registeredUser.uid);
      String downloadUrl =
          await storage.uploadProfilePicture(file: selfieWithIdCard);
      userData.selfieWithIdCardURL = downloadUrl;
      await selfieWithIdCard.delete();
    }

    final database = FirestoreService(uid: registeredUser.uid);
    await database.setUserData(userData);
    return "success";
  } catch (e) {
    print(e);
    return e;
  }
}

Future<String> signIn(
    BuildContext context, String email, String password) async {
  try {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final loggedUser = await auth.signInWithEmailAndPassword(email, password);
    if (loggedUser is String) {
      return loggedUser;
    }
    return "success";
  } catch (e) {
    print(e);
    return e;
  }
}

Future<String> sendPasswordResetEmail(
    BuildContext context, String email) async {
  try {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final message = await auth.sendPasswordResetEmail(email);
    if (message is String) {
      return message;
    }
    return "Success, Please check your email at " +
        email +
        " and reset your password";
  } catch (e) {
    print(e);
    return e;
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
