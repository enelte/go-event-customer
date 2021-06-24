import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/display_name.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/profile_pic.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Service.dart';
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
    final database = Provider.of<FirestoreService>(context, listen: false);
    final Map serviceMap = ModalRoute.of(context).settings.arguments;
    String serviceId = serviceMap['serviceId'];
    return StreamBuilder<Service>(
        stream: database.serviceStream(serviceId: serviceId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Service service = snapshot.data;
            return Scaffold(
              appBar:
                  CustomAppBar(title: Text("Image Gallery"), backButton: true),
              body: MainBackground(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      service.images.isNotEmpty
                          ? ProfilePic(imageURL: service.images[0])
                          : Container(
                              height: 30,
                            ),
                      displayName(service.serviceName, service.serviceType,
                          service.price.toString()),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 12, bottom: 5),
                              child: Text(
                                "Image Gallery",
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 16),
                              ),
                            ),
                            GridView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: service.images.length + 1,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? Container(
                                          child: IconButton(
                                            icon: Icon(Icons.add_a_photo),
                                            color: Colors.white,
                                            onPressed: () async {
                                              File image = await chooseImage();
                                              if (image != null) {
                                                loadingSnackBar(
                                                    context, "Adding Image...");
                                                addImage(
                                                    context, service, image);
                                              }
                                            },
                                          ),
                                          decoration: BoxDecoration(
                                              gradient: kPrimaryGradient),
                                          margin: EdgeInsets.all(4),
                                        )
                                      : Stack(
                                          fit: StackFit.expand,
                                          clipBehavior: Clip.none,
                                          children: [
                                              Container(
                                                margin: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(service
                                                        .images[index - 1]),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: SizedBox(
                                                  height: 35,
                                                  width: 35,
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      loadingSnackBar(context,
                                                          "Deleting Image...");
                                                      deleteImage(context,
                                                          service, index);
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
                  ),
                ),
              ),
              bottomNavigationBar: CustomBottomNavigationBar(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<File> chooseImage() async {
    final imagePicker = Provider.of<ImagePickerService>(context, listen: false);
    File imagePicked = await imagePicker.pickImage(source: ImageSource.gallery);
    return imagePicked;
  }

  Future deleteImage(BuildContext context, Service service, int index) async {
    final storage = Provider.of<FirebaseStorageService>(context, listen: false);
    final database = Provider.of<FirestoreService>(context, listen: false);
    //hapus dari storage
    await storage.deleteImage(imageURL: service.images[index - 1]);
    //hapus url nya dari db
    service.images.removeAt(index - 1);
    await database.setService(service);
  }

  Future addImage(BuildContext context, Service service, File image) async {
    final storage = Provider.of<FirebaseStorageService>(context, listen: false);
    final database = Provider.of<FirestoreService>(context, listen: false);
    final imageURL = await storage.uploadServiceImage(
        index: service.images.length,
        file: image,
        serviceId: service.serviceId);
    service.images.add(imageURL);
    await database.setService(service);
  }
}
