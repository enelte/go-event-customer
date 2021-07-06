import 'package:flutter/material.dart';
import 'package:go_event_customer/components/text_field_container.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/validator.dart';

class RoundedPasswordField extends StatelessWidget {
  final double width;
  final TextEditingController controller;
  final Function validator;
  const RoundedPasswordField({
    Key key,
    this.controller,
    this.width = 270,
    this.validator = Validator.defaultValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        controller: controller,
        cursorColor: kPrimaryColor,
        validator: validator,
        decoration: InputDecoration(
          hintText: "Password",
          prefixIcon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          fillColor: kPrimaryLightColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: kPrimaryLightColor,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: kPrimaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
      width: width,
    );
  }
}
