import 'package:flutter/material.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

Future<void> setEvent(BuildContext context, Event event) async {
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.setEvent(event);
  } catch (e) {
    print(e);
  }
}

Future<void> deleteEvent(BuildContext context, Event event) async {
  try {
    final database = Provider.of<FirestoreService>(context, listen: false);
    await database.deleteEvent(eventId: event.eventId);
  } catch (e) {
    print(e);
  }
}
