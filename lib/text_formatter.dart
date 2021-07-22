import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class TextFormatter {
  TextFormatter._();

  static String moneyFormatter(num numPrice) {
    String price = numPrice.toString();
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
      return value + " IDR";
    }
    return price + " IDR";
  }

  static String dateTimeFormatter(DateTime date) {
    DateFormat dateFormat = DateFormat("dd MMM yyyy hh:mm a");
    return dateFormat.format(date);
  }

  static TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }
}

class CurrencyTextFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    num value = num.parse(newValue.text);

    String newText = TextFormatter.moneyFormatter(value).split(" ")[0];

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
