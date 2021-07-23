import 'package:flutter/material.dart';
import 'package:go_event_customer/components/text_field_container.dart';
import 'package:go_event_customer/constant.dart';

class DropDownInputField extends StatelessWidget {
  @required
  final String title;
  @required
  final dynamic value;
  @required
  final List<DropdownMenuItem> dropDownItems;
  final String hintText;
  final String prefixText;
  final String suffixText;
  final IconData icon;
  final double width;
  final ValueChanged<dynamic> onChanged;

  const DropDownInputField(
      {Key key,
      this.title,
      this.value,
      this.hintText,
      this.prefixText,
      this.suffixText,
      this.icon,
      this.width = 270,
      this.onChanged,
      this.dropDownItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldContainer(
          child: DropdownButtonFormField(
            items: dropDownItems,
            onChanged: onChanged,
            value: value,
            validator: (value) => value == null ? 'Field Required' : null,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              prefixIcon: icon != null
                  ? Icon(
                      icon,
                      color: kPrimaryColor,
                    )
                  : null,
              fillColor: kPrimaryLightColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: kPrimaryLightColor,
                  )),
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
            ),
          ),
          width: width,
        ),
      ],
    );
  }
}
