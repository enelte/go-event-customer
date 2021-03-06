import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Service/components/services_list.dart';
import 'package:go_event_customer/components/main_background.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            ServiceList()
          ],
        ),
      ),
    );
  }
}
