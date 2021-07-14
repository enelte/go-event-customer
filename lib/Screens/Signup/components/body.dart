import 'dart:io';
import 'package:go_event_customer/validator.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Signup/components/background.dart';
import 'package:go_event_customer/components/already_have_an_account_acheck.dart';
import 'package:go_event_customer/components/profile_pic.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/components/rounded_password_field.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/controllers/user_controller.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File imageFile;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _dobController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(60),
              ),
              child: Column(
                children: [
                  ProfilePic(
                    imageFile: imageFile,
                    resetImage: () async {
                      imageFile = null;
                      setState(() {});
                    },
                    pickImage: () async {
                      final imagePicker = Provider.of<ImagePickerService>(
                          context,
                          listen: false);
                      File imagePicked = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (imagePicked != null) imageFile = imagePicked;
                      setState(() {});
                    },
                  ),
                  RoundedInputField(
                    hintText: "Full Name",
                    controller: _nameController,
                  ),
                  RoundedInputField(
                    hintText: "Email",
                    controller: _emailController,
                  ),
                  RoundedInputField(
                    hintText: "Phone Number",
                    icon: Icons.phone,
                    controller: _phoneNumberController,
                    validator: Validator.phoneNumberValidator,
                    digitInput: true,
                  ),
                  RoundedInputField(
                    hintText: "Address",
                    maxLines: 2,
                    icon: Icons.home,
                    controller: _addressController,
                  ),
                  RoundedInputField(
                    hintText: "City",
                    icon: Icons.location_city,
                    controller: _cityController,
                  ),
                  RoundedInputField(
                    hintText: "Date Of Birth",
                    icon: Icons.date_range,
                    controller: _dobController,
                    readOnly: true,
                    suffix: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                        child: Text("Select",
                            style: TextStyle(
                                fontSize: 11, color: kPrimaryLightColor)),
                        onPressed: () async {
                          DateFormat dateFormat = DateFormat("dd MMMM yyyy");
                          final DateTime dob = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(1960),
                            lastDate: DateTime.now(),
                            errorFormatText: 'Enter valid date',
                            errorInvalidText: 'Enter date in valid range',
                            fieldLabelText: 'Date of Birth',
                            fieldHintText: 'Month/Date/Year',
                            initialEntryMode: DatePickerEntryMode.input,
                          );

                          if (dob != null && dob != _selectedDate) {
                            setState(() {
                              _selectedDate = dob;
                              _dobController.text =
                                  dateFormat.format(_selectedDate);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  RoundedInputField(
                    hintText: "Description",
                    maxLines: 4,
                    icon: Icons.description,
                    controller: _descriptionController,
                  ),
                  RoundedPasswordField(
                    controller: _passwordController,
                  ),
                  RoundedButton(
                      text: "SIGNUP",
                      press: () {
                        final userData = UserModel(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          displayName: _nameController.text.trim(),
                          phoneNumber: _phoneNumberController.text.trim(),
                          address: _addressController.text.trim(),
                          dateOfBirth: _dobController.text.trim(),
                          city: _cityController.text.trim(),
                          description: _descriptionController.text.trim(),
                        );
                        signUp(context, userData, imageFile);
                      }),
                ],
              ),
            ),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.of(context).pushNamed(Routes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
