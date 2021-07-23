import 'dart:io';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/date_picker.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:go_event_customer/validator.dart';

import 'package:flutter/material.dart';
import 'package:go_event_customer/components/already_have_an_account_acheck.dart';
import 'package:go_event_customer/components/profile_pic.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/components/rounded_password_field.dart';
import 'package:go_event_customer/controllers/user_controller.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/routes.dart';
import 'package:go_event_customer/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'background.dart';

class CustomerSignUp extends StatefulWidget {
  @override
  _CustomerSignUpState createState() => _CustomerSignUpState();
}

class _CustomerSignUpState extends State<CustomerSignUp> {
  final _formKey = GlobalKey<FormState>();
  File imageFile;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _dobController = TextEditingController();
  final _descriptionController = TextEditingController();
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(30),
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
                      icon: Icons.person,
                      title: "Full Name",
                      controller: _nameController,
                      validator: Validator.displayNameValidator,
                    ),
                    RoundedInputField(
                      title: "Email",
                      icon: Icons.mail,
                      controller: _emailController,
                      validator: Validator.emailValidator,
                    ),
                    Container(
                      width: 270,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          "Please use different email if you are already signed up as Vendor",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ),
                    RoundedInputField(
                      title: "Phone Number",
                      icon: Icons.phone,
                      prefixText: "+62 ",
                      controller: _phoneNumberController,
                      validator: Validator.phoneNumberValidator,
                      digitInput: true,
                    ),
                    RoundedInputField(
                      title: "Address",
                      maxLines: 4,
                      icon: Icons.home,
                      controller: _addressController,
                      validator: Validator.addressValidator,
                    ),
                    RoundedInputField(
                      title: "City",
                      icon: Icons.location_city,
                      controller: _cityController,
                      validator: Validator.cityValidator,
                      onChanged: (value) {
                        if (value != "")
                          _cityController.text = value.toUpperCase();
                        _cityController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _cityController.text.length));
                      },
                    ),
                    RoundedInputField(
                      title: "Date Of Birth",
                      icon: Icons.date_range,
                      controller: _dobController,
                      readOnly: true,
                      validator: Validator.dateValidator,
                      onTap: () async {
                        pickDate(
                            context: context,
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                            dateController: _dobController,
                            onDatePicked: (dob, dateFormat) {
                              _dobController.text = dateFormat.format(dob);
                            });
                      },
                    ),
                    RoundedInputField(
                      title: "Description",
                      maxLines: 4,
                      icon: Icons.description,
                      controller: _descriptionController,
                      validator: Validator.noValidator,
                    ),
                    RoundedPasswordField(
                      controller: _passwordController,
                      validator: Validator.passwordValidator,
                    ),
                    RoundedButton(
                        text: "SIGNUP",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            final userData = UserModel(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              displayName: _nameController.text.trim(),
                              phoneNumber: _phoneNumberController.text.trim(),
                              address: _addressController.text.trim(),
                              dateOfBirth: _dobController.text.trim(),
                              city: _cityController.text.trim(),
                              description: _descriptionController.text.trim(),
                              role: "Customer",
                            );
                            errorMessage =
                                await signUp(context, userData, imageFile);
                            if (errorMessage != "success") setState(() {});
                          }
                        }),
                    if (errorMessage != "success" && errorMessage != null)
                      Text(
                        errorMessage.replaceAll("-", " "),
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }
}
