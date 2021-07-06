import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_event_customer/components/event_card.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/controllers/event_controller.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _budgetController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.only(
          right: getProportionateScreenWidth(5),
        ),
        child: StreamBuilder(
          stream: database.eventsStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Event> eventList = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Your Events",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      child: GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: eventList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(5),
                            child: EventCard(event: eventList[index]),
                          );
                        },
                      ),
                    ),
                    Divider(
                      color: kPrimaryColor,
                      height: 20,
                      thickness: 5,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Create New Event",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    RoundedInputField(
                      hintText: "Event Name",
                      controller: _nameController,
                      icon: Icons.event,
                    ),
                    RoundedInputField(
                      hintText: "Event Date",
                      icon: Icons.date_range,
                      controller: _dateController,
                      readOnly: true,
                      suffix: SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: kPrimaryColor),
                          child: Text("Select",
                              style: TextStyle(
                                  fontSize: 11, color: kPrimaryLightColor)),
                          onPressed: () async {
                            DateFormat dateFormat = DateFormat("dd MMMM yyyy");
                            DateTime selectedDate =
                                _dateController.text.trim() != ""
                                    ? dateFormat
                                        .parse(_dateController.text.trim())
                                    : DateTime.now();
                            final DateTime dob = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              errorFormatText: 'Enter valid date',
                              errorInvalidText: 'Enter date in valid range',
                              fieldLabelText: 'Date of Birth',
                              fieldHintText: 'Month/Date/Year',
                              initialEntryMode: DatePickerEntryMode.input,
                            );

                            if (dob != null && dob != selectedDate) {
                              setState(() {
                                _dateController.text = dateFormat.format(dob);
                              });
                            }
                          },
                        ),
                      ),
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
                          final event = Event(
                            eventId: FirebaseFirestore.instance
                                .collection('events')
                                .doc()
                                .id,
                            eventName: _nameController.text.trim(),
                            eventDate: _dateController.text.trim(),
                            eventBudget:
                                double.parse(_budgetController.text.trim()),
                          );
                          createEditEvent(context, event);
                          setState(() {
                            _nameController.text = "";
                            _dateController.text = "";
                            _budgetController.text = "";
                          });
                        }),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("No data available");
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
