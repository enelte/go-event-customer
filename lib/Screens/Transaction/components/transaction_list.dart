import 'package:flutter/material.dart';
import 'package:go_event_customer/components/order_card.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map transactionMap = ModalRoute.of(context).settings.arguments;
    String type;
    if (transactionMap != null) {
      type = transactionMap['type'];
    }
    final database = Provider.of<FirestoreService>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.only(
          right: getProportionateScreenWidth(5),
        ),
        child: StreamBuilder(
          stream: database.transactionsStream(
            queryBuilder: (query) =>
                query.where("transactionType", isEqualTo: type),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Transaction> transactionList = snapshot.data;
              return Container(
                child: GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: transactionList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
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
      ),
    );
  }
}
