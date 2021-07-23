import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/models/ProofOfPayment.dart';
import 'package:go_event_customer/models/Review.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/ServiceType.dart';
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
  Stream<UserModel> specificUserDataStream(String uid) {
    final path = FirestorePath.userData(uid);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => UserModel.fromMap(snapshot.data(), uid));
  }

  Future<void> setService(Service service) async {
    if (service.serviceId == null)
      service.serviceId =
          FirebaseFirestore.instance.collection('services').doc().id;
    final path = FirestorePath.service(service.serviceId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(service.toMap(), SetOptions(merge: true));
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

  //Method to retrieve vendor's services
  Stream<List<Service>> vendorServicesStream({
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

  //Method to delete service entry
  Future<void> deleteService(Service service) async {
    final path = FirestorePath.service(service.serviceId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Stream<List<ServiceType>> serviceTypesStream({
    Query queryBuilder(Query query),
  }) {
    final path = FirestorePath.serviceTypes();
    Query query = FirebaseFirestore.instance.collection(path);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => ServiceType.fromMap(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      return result;
    });
  }

  Stream<ServiceType> serviceTypeStream({@required String typeId}) {
    final path = FirestorePath.serviceType(typeId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots
        .map((snapshot) => ServiceType.fromMap(snapshot.data(), typeId));
  }

  // Create / Update Event
  Future<void> setEvent(Event event) async {
    if (event.eventId == null)
      event.eventId = FirebaseFirestore.instance.collection('events').doc().id;
    final path = FirestorePath.event(uid, event.eventId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(event.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteEvent({@required String eventId}) async {
    final path = FirestorePath.event(uid, eventId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
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
    if (transaction.transactionId == null)
      transaction.transactionId =
          FirebaseFirestore.instance.collection('transactions').doc().id;
    final path = FirestorePath.transaction(transaction.transactionId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(transaction.toMap(), SetOptions(merge: true));
  }

  //Method to delete service entry
  Future<void> deleteTransaction(tran.Transaction transaction) async {
    final path = FirestorePath.transaction(transaction.transactionId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  //Get Specific Event Data
  Stream<tran.Transaction> transactionStream(tran.Transaction transaction) {
    final path = FirestorePath.transaction(transaction.transactionId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        tran.Transaction.fromMap(snapshot.data(), transaction.transactionId));
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

  //Get All Vendor's Transaction
  Stream<List<tran.Transaction>> vendorTransactionsStream({
    Query queryBuilder(Query query),
    int sort(tran.Transaction lhs, tran.Transaction rhs),
  }) {
    final path = FirestorePath.transactions();
    Query query = FirebaseFirestore.instance
        .collection(path)
        .where("vendorId", isEqualTo: uid)
        .where("transactionType", isNotEqualTo: "Planned");

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

  Future<void> setProofOfPayment(ProofOfPayment proofOfPayment) async {
    if (proofOfPayment.proofOfPaymentId == null)
      proofOfPayment.proofOfPaymentId =
          FirebaseFirestore.instance.collection('proofOfPayments').doc().id;
    final path = FirestorePath.proofOfPayment(
        proofOfPayment.transactionId, proofOfPayment.proofOfPaymentId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(proofOfPayment.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteProofOfPayment(
      {@required String proofOfPaymentId, @required String tid}) async {
    final path = FirestorePath.proofOfPayment(tid, proofOfPaymentId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Stream<ProofOfPayment> proofOfPaymentStream(
      {@required String proofOfPaymentId, @required String tid}) {
    final path = FirestorePath.proofOfPayment(tid, proofOfPaymentId);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        ProofOfPayment.fromMap(snapshot.data(), proofOfPaymentId));
  }

  Stream<List<ProofOfPayment>> proofOfPaymentsStream({
    @required String tid,
    Query queryBuilder(Query query),
    int sort(ProofOfPayment lhs, ProofOfPayment rhs),
  }) {
    final path = FirestorePath.proofOfPayments(tid);
    Query query = FirebaseFirestore.instance.collection(path);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              ProofOfPayment.fromMap(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<void> setReview(Review review) async {
    if (review.reviewId == null)
      review.reviewId =
          FirebaseFirestore.instance.collection('reviews').doc().id;
    final path = FirestorePath.review(review.serviceId, review.reviewId);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(review.toMap(), SetOptions(merge: true));
  }

  Stream<List<Review>> reviewsStream({
    @required String serviceId,
    Query queryBuilder(Query query),
    int sort(Review lhs, Review rhs),
  }) {
    final path = FirestorePath.reviews(serviceId);
    Query query = FirebaseFirestore.instance.collection(path);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => Review.fromMap(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }
}
