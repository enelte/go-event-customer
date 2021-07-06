import 'package:flutter/material.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    Key key,
    @required TextEditingController dateController,
    @required String startTime,
    @required String eventId,
    @required String endTime,
    @required num totalPrice,
  })  : _dateController = dateController,
        _startTime = startTime,
        _endTime = endTime,
        _totalPrice = totalPrice,
        _eventId = eventId,
        super(key: key);

  final TextEditingController _dateController;
  final String _startTime;
  final String _endTime;
  final String _eventId;
  final num _totalPrice;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Order Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          width: getProportionateScreenWidth(265),
          decoration: BoxDecoration(
            border: Border.all(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(29),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dateController.text != ""
                    ? Text(
                        _dateController.text,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      )
                    : Container(),
                _eventId != null
                    ? StreamBuilder<Event>(
                        stream: database.eventStream(eventId: _eventId),
                        builder: (context, snapshot) {
                          Event event = snapshot.data;
                          if (snapshot.hasData) {
                            return Text(
                              event.eventName,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        })
                    : Container(),
                (_startTime != null && _endTime != null)
                    ? Text(
                        _startTime + " - " + _endTime,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      )
                    : Container(),
                SizedBox(height: 6),
                Text(
                  "Total Price",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                Text("Rp. " + _totalPrice.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryColor,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
