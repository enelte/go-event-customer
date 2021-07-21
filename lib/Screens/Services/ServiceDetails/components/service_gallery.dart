import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/display_name.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/profile_pic.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/switch_input.dart';
import 'package:go_event_customer/controllers/service_controller.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ServiceGallery extends StatefulWidget {
  ServiceGallery({Key key}) : super(key: key);

  @override
  _ServiceGalleryState createState() => _ServiceGalleryState();
}

class _ServiceGalleryState extends State<ServiceGallery> {
  bool _imageView;
  @override
  void initState() {
    _imageView = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final database = Provider.of<FirestoreService>(context, listen: false);
    final Map serviceMap = ModalRoute.of(context).settings.arguments;
    Service serviceFromMap = serviceMap['service'];
    UserModel vendor = serviceMap['vendor'];
    return Scaffold(
      appBar: CustomAppBar(title: "Image Gallery", backButton: true),
      body: MainBackground(
        child: SingleChildScrollView(
          child: StreamBuilder<Object>(
              stream:
                  database.serviceStream(serviceId: serviceFromMap.serviceId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Service service = snapshot.data;
                  return Column(
                    children: [
                      service.images.isNotEmpty
                          ? ProfilePic(imageURL: service.images[0])
                          : Container(
                              height: 30,
                            ),
                      displayName(service.serviceName, service.serviceType,
                          vendor.displayName),
                      RoundedButton(
                        text: "Upload Image",
                        press: () async {
                          File image = await chooseServiceImage(context);
                          if (image != null) {
                            loadingSnackBar(
                                context: context, text: "Adding Image...");
                            addServiceImage(context, service, image);
                          }
                          setState(() {});
                        },
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 400,
                              child: SwitchInput(
                                  title: "Image Gallery",
                                  status: _imageView,
                                  onChanged: (value) {
                                    _imageView = value;
                                    setState(() {});
                                  },
                                  trueValue: "Grid",
                                  falseValue: "List"),
                            ),
                            GridView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: service.images.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: _imageView ? 3 : 1),
                                itemBuilder: (context, index) {
                                  return Stack(
                                      fit: StackFit.expand,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  service.images[index]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        if (user.role == "Vendor")
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: SizedBox(
                                              height: 35,
                                              width: 35,
                                              child: TextButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.red),
                                                ),
                                                onPressed: () {
                                                  loadingSnackBar(
                                                      context: context,
                                                      text: "Image Deleted");
                                                  deleteServiceImage(
                                                      context, service, index);
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
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
                  );
                } else if (snapshot.hasError) {
                  return Text("No data available");
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
