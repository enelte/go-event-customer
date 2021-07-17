import 'package:flutter/material.dart';

class Validator {
  Validator._();

  static String defaultValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  static String emailValidator(String value) {
    bool isEmail = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!isEmail) return 'Please enter valid email address';
    return null;
  }

  static String noValidator(String value) {
    return null;
  }

  static String passwordValidator(String value) {
    Pattern pattern = r'.{6,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value == null || value.isEmpty) {
      return 'Please enter your password!';
    } else if (!regex.hasMatch(value))
      return 'Password must be longer than 6 character!';
    return null;
  }

  static String dateValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the date!';
    }
    return null;
  }

  static String cityValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the city!';
    }
    return null;
  }

  static String addressValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the address!';
    }
    return null;
  }

  static String phoneNumberValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone Number!';
    }
    return null;
  }

  static String displayNameValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name!';
    }
    return null;
  }

  static String eventNameValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your event name!';
    }
    return null;
  }

  static String budgetValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your budget!';
    }
    return null;
  }

  static num quantityValidator(
      TextEditingController value, int minOrder, int maxOrder) {
    int quantity;
    if (value.text.trim() == "") {
      quantity = 0;
    } else {
      quantity = int.parse(value.text.trim());
      if (quantity < minOrder) {
        quantity = minOrder;
        value.text = quantity.toString();
      }
      if (quantity > maxOrder) {
        quantity = maxOrder;
        value.text = quantity.toString();
      }
    }
    return quantity;
  }
}
