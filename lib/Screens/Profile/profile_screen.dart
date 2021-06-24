import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Profile/component/body.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/models/UserData.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int selectedIndex = 3;
    final database = Provider.of<FirestoreService>(context);
    return Scaffold(
      appBar: CustomAppBar(title: Text("Vendor Profile"), backButton: true),
      body: StreamBuilder<UserDataModel>(
        stream: database.userDataStream(),
        builder: (context, snapshot) {
          UserDataModel userData;
          if (snapshot.hasData) {
            userData = snapshot.data;
            return Body(
              userData: userData,
            );
          } else if (snapshot.hasError) {
            return Text("No data available");
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
      ),
    );
  }
}
