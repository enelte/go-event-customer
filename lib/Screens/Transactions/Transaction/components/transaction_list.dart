import 'package:flutter/material.dart';
import 'package:go_event_customer/components/order_card.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/models/User.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:go_event_customer/sort_and_filter.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    Key key,
    this.searchString,
    this.filter,
    this.sortType,
  }) : super(key: key);

  final String searchString;
  final Transaction filter;
  final String sortType;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserModel>(context);
    final database = Provider.of<FirestoreService>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.all(
          getProportionateScreenWidth(5),
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
                        borderRadius: BorderRadius.circular(15),
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
                  if (filter.transactionType != null)
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
                        filter.transactionType,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                SizedBox(
                  width: 5,
                ),
                if (filter != null)
                  if (filter.status != null)
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
                        filter.status,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                if (filter != null)
                  if (filter.reviewed != null && filter.reviewed == true)
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
                        "Reviewed",
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
              ],
            ),
            StreamBuilder(
              stream: userData.role == "Customer"
                  ? database.transactionsStream(queryBuilder: (query) {
                      return filterTransaction(query, filter);
                    }, sort: (lhs, rhs) {
                      return sortTransaction(lhs, rhs, sortType);
                    })
                  : database.vendorTransactionsStream(queryBuilder: (query) {
                      return filterTransaction(query, filter);
                    }, sort: (lhs, rhs) {
                      return sortTransaction(lhs, rhs, sortType);
                    }),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Transaction> transactionList = searchString == ""
                      ? snapshot.data
                      : snapshot.data.where((Transaction transaction) {
                          return searchKeyword(
                                  searchString, transaction.serviceName) ||
                              searchKeyword(searchString, transaction.location);
                        }).toList();
                  return Container(
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: transactionList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: OrderCard(order: transactionList[index]),
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
