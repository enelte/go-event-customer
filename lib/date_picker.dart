import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

pickDate(
    {@required BuildContext context,
    @required DateTime firstDate,
    @required DateTime lastDate,
    @required TextEditingController dateController,
    @required Function onDatePicked}) async {
  DateFormat dateFormat = DateFormat("dd MMMM yyyy");
  DateTime selectedDate = dateController.text.trim() != ""
      ? dateFormat.parse(dateController.text.trim())
      : DateTime.now();
  final DateTime dob = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: firstDate,
    lastDate: lastDate,
    errorFormatText: 'Enter valid date',
    errorInvalidText: 'Enter date in valid range',
    fieldLabelText: 'Date of Birth',
    fieldHintText: 'Month/Date/Year',
    initialEntryMode: DatePickerEntryMode.input,
  );
  if (dob != null && dob != selectedDate) {
    onDatePicked(dob, dateFormat);
  }
}
