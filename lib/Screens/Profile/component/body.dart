import 'dart:io';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/date_picker.dart';
import 'package:go_event_customer/popup_dialog.dart';
import 'package:go_event_customer/validator.dart';
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

class Body extends StatefulWidget {
  final UserModel userData;
  const Body({Key key, @required this.userData}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
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
        child: Form(
          key: _formKey,
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
                  "+62" + widget.userData.phoneNumber),
              SizedBox(height: 25),
              RoundedInputField(
                title: "Display Name",
                hintText: "Display Name",
                icon: Icons.person,
                controller: _nameController,
                validator: Validator.displayNameValidator,
              ),
              RoundedInputField(
                title: "Phone Number",
                hintText: "Phone Number",
                prefixText: "+62 ",
                icon: Icons.phone_android,
                controller: _phoneNumberController,
                validator: Validator.phoneNumberValidator,
                digitInput: true,
              ),
              RoundedInputField(
                title: "Address",
                hintText: "Address",
                icon: Icons.home,
                controller: _addressController,
                validator: Validator.addressValidator,
                maxLines: 4,
              ),
              RoundedInputField(
                  validator: Validator.cityValidator,
                  title: "City",
                  hintText: "City",
                  icon: Icons.location_city,
                  controller: _cityController,
                  onChanged: (value) {
                    if (value != "") _cityController.text = value.toUpperCase();
                    _cityController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _cityController.text.length));
                  }),
              if (widget.userData.role == "Customer")
                RoundedInputField(
                  validator: Validator.dateValidator,
                  hintText: "Date Of Birth",
                  icon: Icons.date_range,
                  controller: _dobController,
                  readOnly: true,
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
                hintText: "Description",
                maxLines: 4,
                icon: Icons.description,
                controller: _descriptionController,
                validator: Validator.noValidator,
              ),
              SizedBox(height: 25),
              RoundedButton(
                  text: "Save Changes",
                  press: () {
                    PopUpDialog.confirmationDialog(
                        context: context,
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            final userData = UserModel(
                                displayName: _nameController.text.trim(),
                                phoneNumber: _phoneNumberController.text.trim(),
                                address: _addressController.text.trim(),
                                dateOfBirth: _dobController.text.trim(),
                                city: _cityController.text.trim(),
                                description: _descriptionController.text.trim(),
                                photoURL: _imageURL);
                            await editUserData(context, userData, imageFile)
                                .then((value) {
                              setState(() {});
                              loadingSnackBar(
                                  context: context, text: "Profile Updated");
                            }).catchError((e) {
                              loadingSnackBar(
                                  context: context,
                                  text: "An error occurred, please contact the developer.",
                                  color: Colors.red);
                            });
                            ;
                          }
                        },
                        title: "Save Profile Data?");
                  }),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
