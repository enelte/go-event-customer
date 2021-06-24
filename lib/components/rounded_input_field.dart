import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_event_customer/components/text_field_container.dart';
import 'package:go_event_customer/constant.dart';

class RoundedInputField extends StatelessWidget {
  final String title;
  final String hintText;
  final String prefixText;
  final String suffixText;
  final IconData icon;
  final int maxLines;
  final double width;
  final bool digitInput;
  final TextEditingController controller;

  const RoundedInputField({
    Key key,
    this.title,
    this.hintText,
    this.prefixText,
    this.suffixText,
    this.icon = Icons.person,
    this.maxLines = 1,
    this.controller,
    this.digitInput = false,
    this.width = 270,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldContainer(
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            maxLines: maxLines,
            controller: controller,
            cursorColor: kPrimaryColor,
            keyboardType: digitInput ? TextInputType.number : null,
            inputFormatters:
                digitInput ? [FilteringTextInputFormatter.digitsOnly] : null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              prefixIcon: Icon(
                icon,
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
              prefixText: prefixText,
              suffixStyle: TextStyle(color: kPrimaryColor),
              suffixText: suffixText,
              labelText: title,
              hintText: hintText,
            ),
          ),
          width: width,
        ),
      ],
    );
  }
}
