import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/UserData.dart';

import 'firestore_path.dart';

class FirestoreService {
  FirestoreService({@required this.uid}) : assert(uid != null);
  final String uid;

  // Create / Update UserData
  Future<void> setUserData(UserDataModel userData) async {
    final path = FirestorePath.userData(uid);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(userData.toMap(), SetOptions(merge: true));
  }

  // Reads the current userData
  Stream<UserDataModel> userDataStream() {
    final path = FirestorePath.userData(uid);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots
        .map((snapshot) => UserDataModel.fromMap(snapshot.data(), uid));
  }

  // Create / Update Service
  Future<void> setService(Service service) async {
    final path = FirestorePath.service(service.serviceId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(service.toMap(), SetOptions(merge: true));
  }

  //Method to delete service entry
  Future<void> deleteService(Service service) async {
    final path = FirestorePath.service(service.serviceId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  //Method to retrieve all services item from the same user based on uid
  Stream<List<Service>> servicesStream(String type) {
    final path = FirestorePath.services();
    final reference = FirebaseFirestore.instance
        .collection(path)
        .where("serviceType", isEqualTo: type);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => Service.fromMap(snapshot.data(), snapshot.id))
          .toList();
      return result;
    });
  }

  // Reads the current service
  Stream<Service> serviceStream({@required String serviceId}) {
    final path = FirestorePath.service(serviceId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots
        .map((snapshot) => Service.fromMap(snapshot.data(), serviceId));
  }
}
