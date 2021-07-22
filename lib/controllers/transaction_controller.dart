import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/models/ProofOfPayment.dart';
import 'package:go_event_customer/models/Review.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/services/firebase_storage_service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

Future<void> setTransaction(
    BuildContext context, Transaction transaction) async {
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setTransaction(transaction);
  } catch (e) {
    print(e);
  }
}

Future<void> submitPlannedTransaction(
    BuildContext context, Transaction transaction) async {
  transaction.transactionType = "On Going";
  transaction.status = "Waiting for Confirmation";
  transaction.transactionDate = DateTime.now().toString();
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setTransaction(transaction);
  } catch (e) {
    print(e);
  }
}

Future<void> confirmTransaction(
    BuildContext context, Transaction transaction) async {
  transaction.status = "Waiting for Payment";
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setTransaction(transaction);
  } catch (e) {
    print(e);
  }
}

Future<void> confirmPayment(
    BuildContext context, Transaction transaction) async {
  transaction.status = "In Progress";
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setTransaction(transaction);
  } catch (e) {
    print(e);
  }
}

Future<void> cancelTransaction(
    BuildContext context, Transaction transaction) async {
  transaction.status = "Cancelled";
  transaction.transactionType = "Cancelled";
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setTransaction(transaction);
  } catch (e) {
    print(e);
  }
}

Future<void> rejectTransaction(
    BuildContext context, Transaction transaction) async {
  transaction.status = "Rejected by Vendor";
  transaction.transactionType = "Cancelled";
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setTransaction(transaction);
  } catch (e) {
    print(e);
  }
}

bool needReConfirmation(Transaction oldTransaction, String notes,
    String bookingDate, String location, String startTime, String endTime) {
  if (oldTransaction.status != "Waiting for Payment") return false;
  if (oldTransaction.notes != notes) return true;
  if (oldTransaction.bookingDate != bookingDate) return true;
  if (oldTransaction.location != location) return true;
  if (oldTransaction.startTime != startTime) return true;
  if (oldTransaction.endTime != endTime) return true;
  return false;
}

Future<void> finishTransaction(
    BuildContext context, Transaction transaction, Service service) async {
  transaction.status = "Finished";
  transaction.transactionType = "Finished";
  if (service.ordered == null) service.ordered = 0;
  service.ordered += 1;
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setTransaction(transaction);
    await database.setService(service);
  } catch (e) {
    print(e);
  }
}

Future setProofOfPayment(
    BuildContext context, ProofOfPayment proofOfPayment, File image) async {
  final storage = Provider.of<FirebaseStorageService>(context, listen: false);
  final database = Provider.of<FirestoreService>(context, listen: false);
  if (image != null) {
    final imageURL = await storage.uploadProofOfPayment(
        file: image,
        transactionId: proofOfPayment.transactionId,
        proofOfPaymentId: proofOfPayment.proofOfPaymentId);
    proofOfPayment.proofOfPaymentPicture = imageURL;
  }
  await database.setProofOfPayment(proofOfPayment);
  Transaction updatedTran = new Transaction(
      transactionId: proofOfPayment.transactionId,
      status: "Waiting for Payment Confirmation");
  await database.setTransaction(updatedTran);
}

Future deleteProofOfPayment(
    BuildContext context, ProofOfPayment proofOfPayment) async {
  final storage = Provider.of<FirebaseStorageService>(context, listen: false);
  final database = Provider.of<FirestoreService>(context, listen: false);
  await storage.deleteImage(imageURL: proofOfPayment.proofOfPaymentPicture);
  await database.deleteProofOfPayment(
      proofOfPaymentId: proofOfPayment.proofOfPaymentId,
      tid: proofOfPayment.transactionId);
}

Future<void> reviewAddedToTransaction(BuildContext context,
    Transaction transaction, Service service, Review review) async {
  transaction.reviewed = true;
  if (service.rating == null) service.rating = 0;
  if (service.review == null) service.review = 0;
  service.rating = ((service.rating * service.review) + review.rating) /
      (service.review + 1);
  service.review += 1;
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setService(service);
    await database.setReview(review);
    await database.setTransaction(transaction);
  } catch (e) {
    print(e);
  }
}
