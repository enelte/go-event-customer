import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/ServiceType.dart';
import 'package:go_event_customer/screens/Services/CreateService/components/body.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

class CreateServiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int selectedIndex = 1;
    final database = Provider.of<FirestoreService>(context);
    return StreamBuilder<Object>(
        stream: database.serviceTypesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ServiceType> typeList = snapshot.data;
            return DefaultTabController(
              initialIndex: 1,
              length: typeList.length,
              child: Scaffold(
                appBar: CustomAppBar(
                  title: "Create Service",
                  backButton: true,
                  bottom: TabBar(
                    tabs: <Widget>[
                      for (var type in typeList)
                        Tab(
                          icon: Icon(iconMapping[type.name]),
                          text: type.name,
                        ),
                    ],
                    indicatorWeight: 5,
                    indicatorColor: kPrimaryLightColor,
                  ),
                ),
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    for (var type in typeList)
                      Body(
                        serviceType: type,
                      ),
                  ],
                ),
                bottomNavigationBar: CustomBottomNavigationBar(
                  currentIndex: selectedIndex,
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
