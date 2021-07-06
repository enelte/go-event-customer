import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Event.dart';

class Body extends StatefulWidget {
  final Event event;
  const Body({Key key, this.event}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.event.eventName;
    _dateController.text = widget.event.eventDate;
    _budgetController.text = widget.event.eventBudget.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Event event = widget.event;
    return MainBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                event.eventName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            Divider(
              color: kPrimaryColor,
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            RoundedInputField(
              title: "Event Name",
              hintText: "Event Name",
              icon: Icons.event,
              controller: _nameController,
            ),
            RoundedInputField(
              title: "Event Date",
              hintText: "Event Date",
              icon: Icons.description,
              controller: _dateController,
              suffix: SizedBox(
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                  child: Text("Select",
                      style:
                          TextStyle(fontSize: 11, color: kPrimaryLightColor)),
                  onPressed: () async {
                    DateFormat dateFormat = DateFormat("dd MMMM yyyy");
                    DateTime selectedDate = _dateController.text.trim() != ""
                        ? dateFormat.parse(_dateController.text.trim())
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
              title: "Event Budget",
              hintText: "Event Budget",
              icon: Icons.money,
              controller: _budgetController,
            ),
            RoundedButton(
              text: "Update Event Data",
              press: () async {
                Navigator.pop(context);
              },
            ),
            Divider(
              color: kPrimaryColor,
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "All Event's Bookings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            BudgetBox(event: event),
            Divider(
              color: kPrimaryColor,
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetBox extends StatelessWidget {
  const BudgetBox({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(29),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Spendings",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5),
              Text(
                "Rp. 1000000",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                "Budget",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5),
              LinearProgressIndicator(
                minHeight: 15,
                value: 1000000 / event.eventBudget,
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                backgroundColor: kPrimaryLightColor,
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "out of Rp. " + event.eventBudget.toStringAsFixed(0),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
