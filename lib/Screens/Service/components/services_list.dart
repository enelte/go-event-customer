import 'package:flutter/material.dart';
import 'package:go_event_customer/components/service_card.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';

class ServiceList extends StatelessWidget {
  const ServiceList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map typeMap = ModalRoute.of(context).settings.arguments;
    String type;
    if (typeMap != null) {
      type = typeMap['type'];
    }
    final database = Provider.of<FirestoreService>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.only(
          right: getProportionateScreenWidth(5),
        ),
        child: StreamBuilder(
          stream: database.servicesStream(
            queryBuilder: (query) =>
                query.where("serviceType", isEqualTo: type),
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Service> serviceList = snapshot.data;
              return Container(
                child: GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: serviceList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
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
      ),
    );
  }
}
