import 'package:flutter/material.dart';
import 'package:go_event_customer/components/create_event_form.dart';
import 'package:go_event_customer/components/event_card.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _eventFormKey = GlobalKey<FormState>();
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
                          childAspectRatio: 1.6,
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
                    CreateEventForm(
                        eventFormKey: _eventFormKey,
                        nameController: _nameController,
                        budgetController: _budgetController,
                        onCreate: () {
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
