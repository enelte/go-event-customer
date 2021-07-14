import 'package:flutter/material.dart';
import 'package:go_event_customer/components/order_card.dart';
import 'package:go_event_customer/controllers/event_controller.dart';
import 'package:go_event_customer/models/Transaction.dart';
import 'package:go_event_customer/size_config.dart';
import 'package:go_event_customer/text_formatter.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Event.dart';

class Body extends StatefulWidget {
  @required
  final Event event;
  @required
  final List<Transaction> transactionList;
  const Body({Key key, this.event, this.transactionList}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  num _totalSpending;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.event.eventName;
    _budgetController.text =
        TextFormatter.moneyFormatter(widget.event.eventBudget).split(" ")[0];
    _totalSpending = 0;
    widget.transactionList.forEach((element) {
      _totalSpending = _totalSpending + element.totalPrice;
    });
    print(widget.event.eventBudget);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Event event = widget.event;
    return MainBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                event.eventName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            Divider(
              color: kPrimaryColor,
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            RoundedInputField(
              title: "Event Name",
              hintText: "Event Name",
              icon: Icons.event,
              controller: _nameController,
            ),
            RoundedInputField(
              title: "Event Budget",
              hintText: "Event Budget",
              icon: Icons.money,
              controller: _budgetController,
              digitInput: true,
              isMoney: true,
            ),
            RoundedButton(
              text: "Update Event",
              press: () async {
                setEvent(
                    context,
                    new Event(
                      eventId: event.eventId,
                      eventName: _nameController.text,
                      eventBudget:
                          num.parse(_budgetController.text.replaceAll(".", "")),
                    ));
                Navigator.pop(context);
              },
            ),
            if (widget.transactionList.length == 0)
              RoundedButton(
                text: "Delete Event",
                press: () async {
                  deleteEvent(context, event);
                  Navigator.pop(context);
                },
              ),
            Divider(
              color: kPrimaryColor,
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "All Event's Bookings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            BudgetBox(
              event: event,
              totalSpending: _totalSpending,
            ),
            Divider(
              color: kPrimaryColor,
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.only(
                  right: getProportionateScreenWidth(5),
                ),
                child: Container(
                  child: GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.transactionList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(5),
                        child: OrderCard(order: widget.transactionList[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetBox extends StatelessWidget {
  const BudgetBox({
    Key key,
    @required this.event,
    @required this.totalSpending,
  }) : super(key: key);

  final Event event;
  final num totalSpending;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 250,
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
              Text(
                "Your Spendings",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5),
              Text(
                TextFormatter.moneyFormatter(totalSpending),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                "Budget",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5),
              LinearProgressIndicator(
                minHeight: 15,
                value: totalSpending / event.eventBudget,
                valueColor: AlwaysStoppedAnimation<Color>(
                    totalSpending <= event.eventBudget
                        ? kPrimaryColor
                        : Colors.redAccent),
                backgroundColor: kPrimaryLightColor,
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "out of " +
                            TextFormatter.moneyFormatter(event.eventBudget),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      totalSpending > event.eventBudget
                          ? Text(
                              "overbudget by " +
                                  TextFormatter.moneyFormatter(
                                      totalSpending - event.eventBudget),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                            )
                          : Text(""),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
