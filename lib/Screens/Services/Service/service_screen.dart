import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Services/Service/components/body.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/search_sort_filter.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/popup_dialog.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/routes.dart';
import 'package:provider/provider.dart';

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final int selectedIndex = 4;
  Service _serviceFilter;
  final _searchController = TextEditingController();
  final _locationController = TextEditingController();
  String _sort, _typeId, _typeName, _category;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final Map filterMap = ModalRoute.of(context).settings.arguments;
    if (filterMap != null) {
      if (_serviceFilter == null) {
        _serviceFilter = filterMap['filter'];
      }
    }
    return Scaffold(
      appBar: CustomAppBar(
        title: "Service Offered",
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
                  _sort = await PopUpDialog.serviceSort(context, _sort);
                  setState(() {});
                },
                filter: () async {
                  _serviceFilter = await PopUpDialog.serviceFilter(context,
                      _typeId, _typeName, _category, _locationController);
                  setState(() {
                    _typeId = null;
                    _category = null;
                    _locationController.text = "";
                    if (_serviceFilter != null) {
                      if (_serviceFilter.serviceType != null)
                        _typeId = _serviceFilter.serviceType;
                      if (_serviceFilter.category != null)
                        _category = _serviceFilter.category;
                      if (_serviceFilter.city != null)
                        _locationController.text = _serviceFilter.city;
                    }
                  });
                },
              ),
            )),
      ),
      body: Body(
        searchString: _searchController.text.trim(),
        filter: _serviceFilter,
        sortType: _sort,
      ),
      floatingActionButton: user.role == "Vendor"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.create_service);
              },
              child: const Icon(Icons.add),
              backgroundColor: kPrimaryColor,
            )
          : null,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
      ),
    );
  }
}
