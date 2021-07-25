import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_event_customer/components/text_field_container.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/text_formatter.dart';
import 'package:go_event_customer/validator.dart';

class RoundedInputField extends StatelessWidget {
  final String title;
  final String hintText;
  final String prefixText;
  final String suffixText;
  final String iconText;
  final Widget suffix;
  final IconData icon;
  final int maxLines;
  final double width;
  final bool digitInput;
  final bool isMoney;
  final bool readOnly;
  final TextEditingController controller;
  final Function validator;
  final Function onTap;
  final Color fillColor;
  final Color iconColor;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onFieldSubmitted;

  const RoundedInputField({
    Key key,
    this.title,
    this.hintText,
    this.prefixText,
    this.suffixText,
    this.icon,
    this.maxLines = 1,
    this.controller,
    this.digitInput = false,
    this.isMoney = false,
    this.width = 270,
    this.suffix,
    this.readOnly = false,
    this.validator = Validator.defaultValidator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.iconColor = kPrimaryColor,
    this.fillColor = kPrimaryLightColor,
    this.iconText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldContainer(
          child: TextFormField(
            style: TextStyle(fontSize: 14),
            textAlignVertical: TextAlignVertical.center,
            maxLines: maxLines,
            controller: controller,
            cursorColor: kPrimaryColor,
            readOnly: readOnly,
            keyboardType: digitInput ? TextInputType.number : null,
            inputFormatters: isMoney
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyTextFormatter()
                  ]
                : digitInput
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            onTap: onTap,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical:20),
              prefixIcon: icon != null
                  ? Icon(
                      icon,
                      color: iconColor,
                    )
                  : iconText != null
                      ? Container(
                          width: 5,
                          child: Text(
                            iconText,
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.center,
                        )
                      : null,
              suffix: suffix,
              fillColor: fillColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: BorderSide(
                    color: kPrimaryLightColor,
                  )),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(
                  color: kPrimaryColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
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
