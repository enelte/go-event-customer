import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Home/components/body.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/models/UserData.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int selectedIndex = 0;
    SizeConfig().init(context);
    final database = Provider.of<FirestoreService>(context);
    return Scaffold(
      appBar: CustomAppBar(
          title: StreamBuilder<UserDataModel>(
              stream: database.userDataStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData = snapshot.data;
                  return Text(
                    "Welcome, " + userData.displayName,
                  );
                } else if (snapshot.hasError) {
                  return Text("No data available");
                }
                return Center(child: CircularProgressIndicator());
              })),
      body: Body(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
      ),
    );
  }
}
