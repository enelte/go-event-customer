import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/search_sort_filter.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/popup_dialog.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:provider/provider.dart';

import 'components/transaction_list.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final int selectedIndex = 1;
  Transaction _transactionFilter;
  final _searchController = TextEditingController();
  String _sort, _typeName, _status;
  bool _reviewed;
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: userData.role == "Customer" ? "My Order" : "Incoming Order",
        backButton: true,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SearchSortFilter(
                searchController: _searchController,
                onChanged: (text) {
                  setState(() {});
                },
                sort: () async {
                  _sort = await PopUpDialog.transactionSort(context, _sort);
                  setState(() {});
                },
                filter: () async {
                  _transactionFilter = await PopUpDialog.transactionFilter(
                      context, _typeName, _status, _reviewed);
                  setState(() {
                    _typeName = null;
                    _status = null;
                    _reviewed = null;
                    if (_transactionFilter != null) {
                      _typeName = _transactionFilter.transactionType;
                      _reviewed = _transactionFilter.reviewed;
                      if (_transactionFilter.status != null)
                        _status = _transactionFilter.status;
                    }
                  });
                },
              ),
            )),
      ),
      body: TransactionList(
        searchString: _searchController.text.trim(),
        filter: _transactionFilter,
        sortType: _sort,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
      ),
    );
  }
}
