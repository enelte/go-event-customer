import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/display_name.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/profile_pic.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/services/firebase_storage_service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ServiceGallery extends StatefulWidget {
  ServiceGallery({Key key}) : super(key: key);

  @override
  _ServiceGalleryState createState() => _ServiceGalleryState();
}

class _ServiceGalleryState extends State<ServiceGallery> {
  @override
  Widget build(BuildContext context) {
    final Map serviceMap = ModalRoute.of(context).settings.arguments;
    Service service = serviceMap['service'];
    UserModel vendor = serviceMap['vendor'];
    return Scaffold(
      appBar: CustomAppBar(title: "Image Gallery", backButton: true),
      body: MainBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              service.images.isNotEmpty
                  ? ProfilePic(imageURL: service.images[0])
                  : Container(
                      height: 30,
                    ),
              displayName(
                  service.serviceName, service.serviceType, vendor.displayName),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12, bottom: 5),
                      child: Text(
                        "Image Gallery",
                        style: TextStyle(color: kPrimaryColor, fontSize: 16),
                      ),
                    ),
                    GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: service.images.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return Stack(
                              fit: StackFit.expand,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(service.images[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ]);
                        }),
                  ],
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  Future<File> chooseImage() async {
    final imagePicker = Provider.of<ImagePickerService>(context, listen: false);
    File imagePicked = await imagePicker.pickImage(source: ImageSource.gallery);
    return imagePicked;
  }
}
