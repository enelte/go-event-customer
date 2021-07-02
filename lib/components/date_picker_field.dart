import 'package:flutter/material.dart';
import 'package:go_event_customer/constant.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  const DatePickerField({
    Key key,
    @required TextEditingController dateController,
    @required this.onDatePicked,
  })  : _dateController = dateController,
        super(key: key);

  final TextEditingController _dateController;
  final Function onDatePicked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: kPrimaryColor),
        child: Text("Select",
            style: TextStyle(fontSize: 11, color: kPrimaryLightColor)),
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
            onDatePicked(dob, dateFormat);
          }
        },
      ),
    );
  }
}
