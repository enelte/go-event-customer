import 'package:flutter/material.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

Future<void> createTransaction(
    BuildContext context, Transaction transaction) async {
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setTransaction(transaction);
  } catch (e) {
    print(e);
  }
}
