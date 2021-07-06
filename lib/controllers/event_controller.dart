import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

Future<void> createEditEvent(BuildContext context, Event event) async {
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setEvent(event);
  } catch (e) {
    print(e);
  }
}
