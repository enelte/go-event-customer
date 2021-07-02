import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/Transaction.dart' as tran;
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

  //Reads vendor data
  Stream<UserModel> vendorDataStream(String vendorId) {
    final path = FirestorePath.userData(vendorId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots
        .map((snapshot) => UserModel.fromMap(snapshot.data(), vendorId));
  }

  //Method to retrieve all services item
  Stream<List<Service>> servicesStream({
    Query queryBuilder(Query query),
    int sort(Service lhs, Service rhs),
  }) {
    final path = FirestorePath.services();
    Query query = FirebaseFirestore.instance
        .collection(path)
        .where('status', isEqualTo: true);

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

  // Create / Update Event
  Future<void> setEvent(Event event) async {
    final path = FirestorePath.event(uid, event.eventId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(event.toMap(), SetOptions(merge: true));
  }

  //Get Specific Event Data
  Stream<Event> eventStream({@required String eventId}) {
    final path = FirestorePath.event(uid, eventId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => Event.fromMap(snapshot.data(), eventId));
  }

  //Get All Event Lists
  Stream<List<Event>> eventsStream({
    Query queryBuilder(Query query),
    int sort(Event lhs, Event rhs),
  }) {
    final path = FirestorePath.events(uid);
    Query query = FirebaseFirestore.instance.collection(path);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => Event.fromMap(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  // Create / Update Transaction
  Future<void> setTransaction(tran.Transaction transaction) async {
    final path = FirestorePath.transaction(transaction.transactionId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(transaction.toMap(), SetOptions(merge: true));
  }

  //Get Specific Event Data
  Stream<Event> transactionStream(tran.Transaction transaction) {
    final path = FirestorePath.transaction(transaction.transactionId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        Event.fromMap(snapshot.data(), transaction.transactionId));
  }

  //Get All User's Transaction
  Stream<List<tran.Transaction>> transactionsStream({
    Query queryBuilder(Query query),
    int sort(tran.Transaction lhs, tran.Transaction rhs),
  }) {
    final path = FirestorePath.transactions();
    Query query = FirebaseFirestore.instance
        .collection(path)
        .where("customerId", isEqualTo: uid);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              tran.Transaction.fromMap(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }
}
