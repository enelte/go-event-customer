import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';

import 'firestore_path.dart';

class FirestoreService {
  FirestoreService({@required this.uid}) : assert(uid != null);
  final String uid;

  // Create / Update UserData
  Future<void> setUserData(UserModel userData) async {
    final path = FirestorePath.userData(uid);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(userData.toMap(), SetOptions(merge: true));
  }

  // Reads the current userData
  Stream<UserModel> userDataStream() {
    final path = FirestorePath.userData(uid);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => UserModel.fromMap(snapshot.data(), uid));
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
  Stream<List<Service>> servicesStream({
    Query queryBuilder(Query query),
    int sort(Service lhs, Service rhs),
  }) {
    final path = FirestorePath.services();
    Query query = FirebaseFirestore.instance
        .collection(path)
        .where("vendorId", isEqualTo: uid);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => Service.fromMap(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
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
