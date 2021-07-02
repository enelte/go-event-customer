import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:go_event_customer/components/display_name.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/profile_pic.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/controllers/user_controller.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/services/auth_service.dart';
import 'package:go_event_customer/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../constant.dart';

class Body extends StatefulWidget {
  final UserModel userData;
  const Body({Key key, @required this.userData}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _dobController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _imageURL;
  File imageFile;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData.displayName;
    _phoneNumberController.text = widget.userData.phoneNumber;
    _addressController.text = widget.userData.address;
    _cityController.text = widget.userData.city;
    _descriptionController.text = widget.userData.description;
    _dobController.text = widget.userData.dateOfBirth;
    _imageURL = widget.userData.photoURL;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseAuthService>(context).getCurrentUser();
    return MainBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePic(
              imageFile: imageFile,
              imageURL: _imageURL,
              resetImage: () async {
                imageFile = null;
                setState(() {});
              },
              pickImage: () async {
                final imagePicker =
                    Provider.of<ImagePickerService>(context, listen: false);
                File imagePicked =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                if (imagePicked != null) imageFile = imagePicked;
                setState(() {});
              },
            ),
            displayName(widget.userData.displayName, user.email,
                widget.userData.phoneNumber),
            SizedBox(height: 25),
            RoundedInputField(
              title: "Display Name",
              hintText: "Display Name",
              icon: Icons.person,
              controller: _nameController,
            ),
            RoundedInputField(
              title: "Phone Number",
              hintText: "Phone Number",
              icon: Icons.phone_android,
              controller: _phoneNumberController,
            ),
            RoundedInputField(
              title: "Address",
              hintText: "Address",
              icon: Icons.home,
              controller: _addressController,
            ),
            RoundedInputField(
              title: "City",
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
                      style:
                          TextStyle(fontSize: 11, color: kPrimaryLightColor)),
                  onPressed: () async {
                    DateFormat dateFormat = DateFormat("dd MMMM yyyy");
                    DateTime selectedDate = _dobController.text.trim() != ""
                        ? dateFormat.parse(_dobController.text.trim())
                        : DateTime.now();
                    final DateTime dob = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now(),
                      errorFormatText: 'Enter valid date',
                      errorInvalidText: 'Enter date in valid range',
                      fieldLabelText: 'Date of Birth',
                      fieldHintText: 'Month/Date/Year',
                      initialEntryMode: DatePickerEntryMode.input,
                    );

                    if (dob != null && dob != selectedDate) {
                      setState(() {
                        _dobController.text = dateFormat.format(dob);
                      });
                    }
                  },
                ),
              ),
            ),
            RoundedInputField(
              title: "Description",
              hintText: "Description",
              maxLines: 4,
              icon: Icons.description,
              controller: _descriptionController,
            ),
            SizedBox(height: 25),
            RoundedButton(
              text: "Save Changes",
              press: () {
                final userData = UserModel(
                    displayName: _nameController.text.trim(),
                    phoneNumber: _phoneNumberController.text.trim(),
                    address: _addressController.text.trim(),
                    dateOfBirth: _dobController.text.trim(),
                    city: _cityController.text.trim(),
                    description: _descriptionController.text.trim(),
                    photoURL: _imageURL);
                editUserData(context, userData, imageFile);
              },
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
