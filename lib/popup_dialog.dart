import 'package:flutter/material.dart';
import 'package:go_event_customer/components/dropdown_input_field.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/components/switch_input.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/controllers/user_controller.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/models/ServiceType.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

class PopUpDialog {
  PopUpDialog._(); //this is to prevent anyone from instantiate this object
  static Future<String> serviceSort(BuildContext context, String sort) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: const Text('Sort Service'),
            content: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RoundedButton(
                    color: sort == "Price High to Low"
                        ? kPrimaryColor
                        : Colors.grey,
                    press: () {
                      setState(() {
                        sort = "Price High to Low";
                      });
                    },
                    text: 'Price High to Low',
                  ),
                  RoundedButton(
                    color: sort == "Price Low to High"
                        ? kPrimaryColor
                        : Colors.grey,
                    press: () {
                      setState(() {
                        sort = "Price Low to High";
                      });
                    },
                    text: 'Price Low to High',
                  ),
                  RoundedButton(
                    color:
                        sort == "Highest Rating" ? kPrimaryColor : Colors.grey,
                    press: () {
                      setState(() {
                        sort = "Highest Rating";
                      });
                    },
                    text: 'Highest Rating',
                  ),
                  RoundedButton(
                    color: sort == "Most Ordered" ? kPrimaryColor : Colors.grey,
                    press: () {
                      setState(() {
                        sort = "Most Ordered";
                      });
                    },
                    text: 'Most Ordered',
                  ),
                  Container(
                    width: 220,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            minWidth: 100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side: BorderSide(color: Colors.green)),
                            color: Colors.white,
                            textColor: Colors.green,
                            onPressed: () {
                              Navigator.pop(context, sort);
                            },
                            child: Text(
                              "Apply Sort",
                            )),
                        MaterialButton(
                            minWidth: 100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side: BorderSide(color: Colors.red)),
                            color: Colors.white,
                            textColor: Colors.red,
                            onPressed: () {
                              Navigator.pop(context, null);
                            },
                            child: Text(
                              "Clear Sort",
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static Future<Service> serviceFilter(
    BuildContext context,
    String _typeId,
    _typeName,
    _category,
    TextEditingController _locationController,
  ) async {
    Service filter;
    return await showDialog<Service>(
      context: context,
      builder: (BuildContext context) {
        final database = Provider.of<FirestoreService>(context, listen: false);
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Filter'),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder<List<ServiceType>>(
                      stream: database.serviceTypesStream(),
                      builder: (context, snapshot) {
                        List<ServiceType> serviceTypeList = [
                          ServiceType(name: "All Venue", typeId: "All Venue")
                        ];
                        if (snapshot.hasData) {
                          serviceTypeList.addAll(snapshot.data);
                          return Column(
                            children: [
                              DropDownInputField(
                                title: "Select Venue Type",
                                width: 274,
                                icon: Icons.star,
                                value: _typeId == null ? "All Venue" : _typeId,
                                dropDownItems:
                                    serviceTypeList.map((ServiceType type) {
                                  return new DropdownMenuItem(
                                      value: type.typeId,
                                      child: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Container(
                                                width: 140,
                                                child: Text(
                                                  type.name,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                )),
                                          ),
                                        ],
                                      ));
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    if (_typeId != newValue) _category = null;
                                    _typeId = newValue;
                                  });
                                  print(_typeId);
                                },
                              ),
                              if (_typeId != null && _typeId != "All Venue")
                                StreamBuilder<ServiceType>(
                                  stream: database.serviceTypeStream(
                                      typeId: _typeId),
                                  builder: (context, snapshot) {
                                    List categoryList = ["All Category"];
                                    if (snapshot.hasData) {
                                      ServiceType serviceType = snapshot.data;
                                      _typeName = serviceType.name;
                                      categoryList.addAll(serviceType.category);
                                      return DropDownInputField(
                                        title: "Select Category",
                                        width: 274,
                                        icon: Icons.star,
                                        value: _category == null
                                            ? "All Category"
                                            : _category,
                                        dropDownItems:
                                            categoryList.map((categoryName) {
                                          return new DropdownMenuItem(
                                              value: categoryName,
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Container(
                                                        width: 140,
                                                        child: Text(
                                                          categoryName,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        )),
                                                  ),
                                                ],
                                              ));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _category = newValue;
                                          });
                                        },
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                              RoundedInputField(
                                title: "Location",
                                hintText: "City (e.g Jakarta)",
                                icon: Icons.location_on,
                                controller: _locationController,
                              )
                            ],
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    Container(
                      width: 220,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                              minWidth: 100,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  side: BorderSide(color: Colors.green)),
                              color: Colors.white,
                              textColor: Colors.green,
                              onPressed: () {
                                if (filter == null) {
                                  filter = new Service();
                                }
                                filter.serviceName = _typeName;
                                filter.serviceType = _typeId;
                                filter.category = _category == "All Category"
                                    ? null
                                    : _category;
                                filter.city =
                                    _locationController.text.trim() == ""
                                        ? null
                                        : _locationController.text.trim();
                                Navigator.pop(context, filter);
                              },
                              child: Text(
                                "Apply Filter",
                              )),
                          MaterialButton(
                              minWidth: 100,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  side: BorderSide(color: Colors.red)),
                              color: Colors.white,
                              textColor: Colors.red,
                              onPressed: () {
                                Navigator.pop(context, null);
                              },
                              child: Text(
                                "Clear Filter",
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static Future<String> transactionSort(
      BuildContext context, String sort) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final userData = Provider.of<UserModel>(context);
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: const Text('Sort Order'),
            content: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RoundedButton(
                    color: sort == "Total Price High to Low"
                        ? kPrimaryColor
                        : Colors.grey,
                    press: () {
                      setState(() {
                        sort = "Total Price High to Low";
                      });
                    },
                    text: 'Total Price High to Low',
                  ),
                  RoundedButton(
                    color: sort == "Total Price Low to High"
                        ? kPrimaryColor
                        : Colors.grey,
                    press: () {
                      setState(() {
                        sort = "Total Price Low to High";
                      });
                    },
                    text: 'Total Price Low to High',
                  ),
                  RoundedButton(
                    color: sort == "Latest Order" ? kPrimaryColor : Colors.grey,
                    press: () {
                      setState(() {
                        sort = "Latest Order";
                      });
                    },
                    text: 'Latest Order',
                  ),
                  RoundedButton(
                    color: sort == "Upcoming Event Date"
                        ? kPrimaryColor
                        : Colors.grey,
                    press: () {
                      setState(() {
                        sort = "Upcoming Event Date";
                      });
                    },
                    text: 'Upcoming Event Date',
                  ),
                  RoundedButton(
                    color: sort == "Customer Name" || sort == "Vendor Name"
                        ? kPrimaryColor
                        : Colors.grey,
                    press: () {
                      setState(() {
                        sort = userData.role == "Vendor"
                            ? "Customer Name"
                            : "Vendor Name";
                      });
                    },
                    text: userData.role == "Vendor"
                        ? "Customer Name"
                        : "Vendor Name",
                  ),
                  Container(
                    width: 220,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            minWidth: 100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side: BorderSide(color: Colors.green)),
                            color: Colors.white,
                            textColor: Colors.green,
                            onPressed: () {
                              Navigator.pop(context, sort);
                            },
                            child: Text(
                              "Apply Sort",
                            )),
                        MaterialButton(
                            minWidth: 100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side: BorderSide(color: Colors.red)),
                            color: Colors.white,
                            textColor: Colors.red,
                            onPressed: () {
                              Navigator.pop(context, null);
                            },
                            child: Text(
                              "Clear Sort",
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  static Future<Transaction> transactionFilter(
    BuildContext context,
    String _typeName,
    _status,
    bool _reviewed,
  ) async {
    Transaction filter;
    if (_reviewed == null) _reviewed = false;
    return await showDialog<Transaction>(
      context: context,
      builder: (BuildContext context) {
        List<String> transactionTypeList = [
          "All Transaction",
          "Planned",
          "On Going",
          "Finished",
          "Cancelled"
        ];
        List<String> transactionStatusList = [
          "All Status",
          "Waiting for Confirmation",
          "Waiting for Payment Confirmation",
          "In Progress",
        ];
        return StatefulBuilder(builder: (context, setState) {
          final user = Provider.of<UserModel>(context);
          if (user.role == "Vendor") transactionTypeList.remove("Planned");
          return AlertDialog(
            title: const Text('Filter'),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DropDownInputField(
                      title: "Select Transaction",
                      width: 274,
                      icon: Icons.star,
                      value: _typeName == null ? "All Transaction" : _typeName,
                      dropDownItems: transactionTypeList.map((String type) {
                        return new DropdownMenuItem(
                            value: type,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Container(
                                      width: 140,
                                      child: Text(
                                        type,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                      )),
                                ),
                              ],
                            ));
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _typeName = newValue;
                          if (_typeName != "On Going") _status = null;
                          print(_typeName);
                        });
                      },
                    ),
                    if (_typeName == "On Going")
                      DropDownInputField(
                        title: "Select Status",
                        width: 274,
                        icon: Icons.star,
                        value: _status == null ? "All Status" : _status,
                        dropDownItems:
                            transactionStatusList.map((String status) {
                          return new DropdownMenuItem(
                              value: status,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Container(
                                        width: 140,
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        )),
                                  ),
                                ],
                              ));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _status = newValue;
                            print(_status);
                          });
                        },
                      ),
                    if (_typeName == "Finished")
                      SwitchInput(
                          title: "Reviewed",
                          status: _reviewed,
                          onChanged: (value) {
                            setState(() {
                              _reviewed = value;
                            });
                          },
                          trueValue: "Yes",
                          falseValue: "No"),
                    Container(
                      width: 220,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                              minWidth: 100,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  side: BorderSide(color: Colors.green)),
                              color: Colors.white,
                              textColor: Colors.green,
                              onPressed: () {
                                if (filter == null) {
                                  filter = new Transaction();
                                }
                                filter.transactionType =
                                    _typeName == "All Transaction"
                                        ? null
                                        : _typeName;
                                filter.status =
                                    _status == "All Status" ? null : _status;
                                filter.reviewed = _reviewed;
                                Navigator.pop(context, filter);
                              },
                              child: Text(
                                "Apply Filter",
                              )),
                          MaterialButton(
                              minWidth: 100,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                  side: BorderSide(color: Colors.red)),
                              color: Colors.white,
                              textColor: Colors.red,
                              onPressed: () {
                                Navigator.pop(context, null);
                              },
                              child: Text(
                                "Clear Filter",
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static confirmationDialog(
      {@required BuildContext context,
      @required Function onPressed,
      @required String title}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            title: Text(title),
            content: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 220,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            minWidth: 100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side: BorderSide(color: Colors.green)),
                            color: Colors.white,
                            textColor: Colors.green,
                            onPressed: () {
                              onPressed();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Yes",
                            )),
                        MaterialButton(
                            minWidth: 100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side: BorderSide(color: Colors.red)),
                            color: Colors.white,
                            textColor: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "No",
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
