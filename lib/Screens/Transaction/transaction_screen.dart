import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/search_sort_filter.dart';
import 'package:go_event_customer/screens/Transaction/components/body.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int selectedIndex = 1;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Your Orders",
        backButton: true,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SearchSortFilter(),
            )),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
      ),
    );
  }
}
