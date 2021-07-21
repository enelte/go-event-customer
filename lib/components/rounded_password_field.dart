import 'package:flutter/material.dart';
import 'package:go_event_customer/components/text_field_container.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/validator.dart';

class RoundedPasswordField extends StatefulWidget {
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
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  FocusNode focusNode = FocusNode();
  bool visibility = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: visibility,
        style: TextStyle(fontSize: 14),
        controller: widget.controller,
        cursorColor: kPrimaryColor,
        validator: widget.validator,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: "Password",
          prefixIcon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.visibility),
            color: kPrimaryColor,
            onPressed: () async {
              focusNode.unfocus();
              focusNode.canRequestFocus = false;
              setState(() {
                visibility = visibility ? false : true;
              });
              Future.delayed(Duration(milliseconds: 100), () {
                focusNode.canRequestFocus = true;
              });
            },
          ),
          fillColor: kPrimaryLightColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: kPrimaryLightColor,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: kPrimaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
      width: widget.width,
    );
  }
}
