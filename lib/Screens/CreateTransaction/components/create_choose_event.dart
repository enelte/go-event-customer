import 'package:flutter/material.dart';
import 'package:go_event_customer/components/create_event_form.dart';
import 'package:go_event_customer/components/dropdown_input_field.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ChooseEvent extends StatelessWidget {
  ChooseEvent({
    Key key,
    @required TextEditingController nameController,
    @required TextEditingController budgetController,
    @required String eventId,
    @required this.onCreate,
    @required this.onSelected,
  })  : _nameController = nameController,
        _budgetController = budgetController,
        _eventId = eventId,
        super(key: key);

  final _eventFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController;
  final TextEditingController _budgetController;
  final Function onCreate, onSelected;
  final String _eventId;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    return Column(
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
        CreateEventForm(
            eventFormKey: _eventFormKey,
            nameController: _nameController,
            budgetController: _budgetController,
            onCreate: onCreate),
      ],
    );
  }
}
