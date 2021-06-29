import 'package:flutter/material.dart';
import 'package:go_event_customer/models/Transaction.dart';
import '../constant.dart';
import '../size_config.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    Key key,
    this.width = 140,
    this.aspectRetio = 1.02,
    @required this.order,
  }) : super(key: key);

  final double width, aspectRetio;
  final Transaction order;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(5)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () => {},
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: AspectRatio(
                    aspectRatio: 1.1,
                    // child: Container(
                    //     decoration: BoxDecoration(
                    //       color: kPrimaryLightColor,
                    //     ),
                    //     child: Padding(
                    //       padding:
                    //           EdgeInsets.all(getProportionateScreenWidth(8)),
                    //       child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               order.eventName,
                    //               style: TextStyle(
                    //                 color: kPrimaryColor,
                    //                 fontSize: getProportionateScreenWidth(16),
                    //               ),
                    //               maxLines: 2,
                    //             ),
                    //             Padding(
                    //               padding: EdgeInsets.only(
                    //                   top: getProportionateScreenHeight(5)),
                    //               child: Row(
                    //                 children: [
                    //                   Icon(Icons.person,
                    //                       size:
                    //                           getProportionateScreenWidth(10)),
                    //                   Text(
                    //                     order.customerName,
                    //                     textAlign: TextAlign.center,
                    //                     style: TextStyle(
                    //                       fontSize:
                    //                           getProportionateScreenWidth(10),
                    //                       color: Colors.black,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: EdgeInsets.only(
                    //                   top: getProportionateScreenHeight(5)),
                    //               child: Row(
                    //                 children: [
                    //                   Icon(Icons.calendar_today,
                    //                       size:
                    //                           getProportionateScreenWidth(10)),
                    //                   Text(
                    //                     order.date,
                    //                     textAlign: TextAlign.center,
                    //                     style: TextStyle(
                    //                       fontSize:
                    //                           getProportionateScreenWidth(10),
                    //                       color: Colors.black,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ]),
                    //     )),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      EdgeInsets.only(left: getProportionateScreenWidth(2)),
                  child: SizedBox(
                      child: Text(
                        order.status,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                        maxLines: 2,
                      ),
                      height: getProportionateScreenHeight(30)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
