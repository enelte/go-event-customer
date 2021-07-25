import 'dart:io';
import 'package:go_event_customer/components/upload_image.dart';
import 'package:go_event_customer/constant.dart';
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

class VendorSignUp extends StatefulWidget {
  @override
  _VendorSignUpState createState() => _VendorSignUpState();
}

class _VendorSignUpState extends State<VendorSignUp> {
  final _formKey = GlobalKey<FormState>();
  File profilePictureFile, idCardFile, selfieWithIdCardFile;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAccountNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
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
                      imageFile: profilePictureFile,
                      resetImage: () async {
                        profilePictureFile = null;
                        setState(() {});
                      },
                      pickImage: () async {
                        final imagePicker = Provider.of<ImagePickerService>(
                            context,
                            listen: false);
                        File imagePicked = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (imagePicked != null)
                          profilePictureFile = imagePicked;
                        setState(() {});
                      },
                    ),
                    Container(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "1. General Information",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    RoundedInputField(
                      icon: Icons.group,
                      title: "Vendor Name",
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
                          "Please use different email if you are already signed up as Customer",
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
                          _cityController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: _cityController.text.length));
                        }),
                    RoundedInputField(
                      title: "Description",
                      maxLines: 4,
                      icon: Icons.description,
                      controller: _descriptionController,
                      validator: Validator.noValidator,
                    ),
                    RoundedPasswordField(
                      controller: _passwordController,
                      validator: Validator.defaultValidator,
                    ),
                    Container(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "2. Bank Account Information",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    RoundedInputField(
                      title: "Bank Name",
                      hintText: "BCA, Mandiri, BRI, etc.",
                      icon: Icons.attach_money,
                      controller: _bankNameController,
                      validator: Validator.defaultValidator,
                    ),
                    RoundedInputField(
                      title: "Bank Account Number",
                      icon: Icons.format_list_numbered,
                      controller: _bankAccountNumberController,
                      validator: Validator.defaultValidator,
                    ),
                    RoundedInputField(
                      title: "Account Name",
                      hintText: "Name registered on the account",
                      icon: Icons.person,
                      controller: _bankAccountNameController,
                      validator: Validator.defaultValidator,
                    ),
                    Container(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "3. Vendor Verification Information",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          "1. ID Card Photo (KTP)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                      ),
                    ),
                    UploadImage(
                      height: 200,
                      imageFile: idCardFile,
                      resetImage: () async {
                        idCardFile = null;
                        setState(() {});
                      },
                      pickImage: () async {
                        final imagePicker = Provider.of<ImagePickerService>(
                            context,
                            listen: false);
                        File imagePicked = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (imagePicked != null) idCardFile = imagePicked;
                        setState(() {});
                      },
                    ),
                    Container(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          "2. Selfie with ID Card Photo",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                      ),
                    ),
                    UploadImage(
                      height: 300,
                      imageFile: selfieWithIdCardFile,
                      resetImage: () async {
                        selfieWithIdCardFile = null;
                        setState(() {});
                      },
                      pickImage: () async {
                        final imagePicker = Provider.of<ImagePickerService>(
                            context,
                            listen: false);
                        File imagePicked = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (imagePicked != null)
                          selfieWithIdCardFile = imagePicked;
                        setState(() {});
                      },
                    ),
                    RoundedButton(
                        text: "SIGNUP",
                        press: () async {
                          if (_formKey.currentState.validate()) {
                            if (idCardFile == null ||
                                selfieWithIdCardFile == null) {
                              errorMessage =
                                  "Please Complete the Vendor Verification Information";
                            } else {
                              final userData = UserModel(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                displayName: _nameController.text.trim(),
                                phoneNumber: _phoneNumberController.text.trim(),
                                address: _addressController.text.trim(),
                                city: _cityController.text.trim(),
                                description: _descriptionController.text.trim(),
                                role: "Vendor",
                                registrationStatus: false,
                                bankName: _bankNameController.text.trim(),
                                bankAccountName:
                                    _bankAccountNameController.text.trim(),
                                bankAccountNumber:
                                    _bankAccountNumberController.text.trim(),
                              );
                              errorMessage = await signUp(
                                  context: context,
                                  userData: userData,
                                  profilePicture: profilePictureFile,
                                  idCard: idCardFile,
                                  selfieWithIdCard: selfieWithIdCardFile);
                            }
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
