import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_event_customer/components/dropdown_input_field.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/controllers/event_controller.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatelessWidget {
  CreateEvent({
    Key key,
    @required TextEditingController nameController,
    @required TextEditingController budgetController,
    @required TextEditingController dateController,
    @required String eventId,
    @required this.onCreate,
    @required this.onSelected,
  })  : _nameController = nameController,
        _budgetController = budgetController,
        _dateController = dateController,
        _eventId = eventId,
        super(key: key);

  final _eventFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController;
  final TextEditingController _budgetController;
  final TextEditingController _dateController;
  final Function onCreate, onSelected;
  final String _eventId;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    return Form(
      key: _eventFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Choose Existing Event",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          StreamBuilder<List<Event>>(
            stream: database.eventsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Event> eventList = snapshot.data;
                return DropDownInputField(
                  title: "Select Event",
                  width: 274,
                  icon: Icons.star,
                  value: _eventId,
                  dropDownItems: eventList.map((Event event) {
                    return new DropdownMenuItem(
                        value: event.eventId,
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Container(
                                  width: 160,
                                  child: Text(
                                    event.eventName,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  )),
                            ),
                          ],
                        ));
                  }).toList(),
                  onChanged: onSelected,
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Text(
            "Or you can create first before selecting",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Create New Event",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          RoundedInputField(
            hintText: "Event Name",
            controller: _nameController,
            icon: Icons.event,
          ),
          RoundedInputField(
            hintText: "Event Budget",
            icon: Icons.money,
            controller: _budgetController,
            digitInput: true,
          ),
          RoundedButton(
              text: "Create Event",
              press: () {
                if (_eventFormKey.currentState.validate()) {
                  final event = Event(
                    eventId: FirebaseFirestore.instance
                        .collection('events')
                        .doc()
                        .id,
                    eventName: _nameController.text.trim(),
                    eventDate: _dateController.text.trim(),
                    eventBudget: double.parse(_budgetController.text.trim()),
                  );
                  createEditEvent(context, event);
                  onCreate();
                }
              }),
        ],
      ),
    );
  }
}
