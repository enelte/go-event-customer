import 'package:flutter/material.dart';
import 'package:go_event_customer/components/service_card.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/sort_and_filter.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
    this.searchString,
    this.filter,
    this.sortType,
  }) : super(key: key);

  final String searchString;
  final Service filter;
  final String sortType;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context);
    final database = Provider.of<FirestoreService>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.only(
          right: getProportionateScreenWidth(5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (sortType != null)
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    minWidth: 50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                        side: BorderSide(color: kPrimaryColor)),
                    color: Colors.white,
                    disabledTextColor: kPrimaryColor,
                    onPressed: null,
                    child: Text(
                      sortType,
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                SizedBox(
                  width: 5,
                ),
                if (filter != null)
                  if (filter.serviceName != null)
                    MaterialButton(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      minWidth: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: BorderSide(color: kPrimaryColor)),
                      color: Colors.white,
                      disabledTextColor: kPrimaryColor,
                      onPressed: null,
                      child: Text(
                        filter.serviceName,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                SizedBox(
                  width: 5,
                ),
                if (filter != null)
                  if (filter.category != null)
                    MaterialButton(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      minWidth: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: BorderSide(color: kPrimaryColor)),
                      color: Colors.white,
                      disabledTextColor: kPrimaryColor,
                      onPressed: null,
                      child: Text(
                        filter.category,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                SizedBox(
                  width: 5,
                ),
                if (filter != null)
                  if (filter.city != null)
                    MaterialButton(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      minWidth: 50,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                          side: BorderSide(color: kPrimaryColor)),
                      color: Colors.white,
                      disabledTextColor: kPrimaryColor,
                      onPressed: null,
                      child: Text(
                        filter.city,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
              ],
            ),
            StreamBuilder(
              stream: userData.role == "Customer"
                  ? database.servicesStream(queryBuilder: (query) {
                      return filterService(query, filter);
                    }, sort: (lhs, rhs) {
                      return sortService(lhs, rhs, sortType);
                    })
                  : database.vendorServicesStream(queryBuilder: (query) {
                      return filterService(query, filter);
                    }, sort: (lhs, rhs) {
                      return sortService(lhs, rhs, sortType);
                    }),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //apply search
                  List<Service> serviceList = searchString == ""
                      ? snapshot.data
                      : snapshot.data
                          .where((service) =>
                              searchKeyword(searchString, service.serviceName))
                          .toList();
                  return Container(
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: serviceList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.69,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: ServiceCard(service: serviceList[index]),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text("No data available");
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
