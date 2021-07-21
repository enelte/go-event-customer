import 'package:flutter/material.dart';
import 'package:go_event_customer/components/custom_app_bar.dart';
import 'package:go_event_customer/components/custom_bottom_navbar.dart';
import 'package:go_event_customer/components/main_background.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/components/star_rating.dart';
import 'package:go_event_customer/constant.dart';
import 'package:go_event_customer/models/Review.dart';
import 'package:go_event_customer/models/Service.dart';
import 'package:go_event_customer/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ServiceReview extends StatefulWidget {
  ServiceReview({Key key}) : super(key: key);

  @override
  _ServiceReviewState createState() => _ServiceReviewState();
}

class _ServiceReviewState extends State<ServiceReview> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreService>(context, listen: false);
    final Map serviceMap = ModalRoute.of(context).settings.arguments;
    Service service = serviceMap['service'];
    return Scaffold(
      appBar: CustomAppBar(title: "Reviews and Rating", backButton: true),
      body: MainBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<Object>(
                  stream: database.reviewsStream(serviceId: service.serviceId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Review> reviewList = snapshot.data;
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 12, bottom: 5),
                              child: Text(
                                "Reviews and Rating",
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GridView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: reviewList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio: 1.5),
                                itemBuilder: (context, index) {
                                  final _commentController =
                                      TextEditingController(
                                          text: reviewList[index].comment);
                                  return Container(
                                    margin: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 5.0,
                                          offset: Offset(2, 6),
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    color: kPrimaryColor,
                                                  ),
                                                  Text(
                                                    reviewList[index]
                                                                .customerName !=
                                                            null
                                                        ? reviewList[index]
                                                            .customerName
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  StarRating(
                                                    value: reviewList[index]
                                                        .rating,
                                                    onChanged: null,
                                                    size: 18,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: kPrimaryColor,
                                          height: 20,
                                          thickness: 2,
                                          indent: 20,
                                          endIndent: 20,
                                        ),
                                        RoundedInputField(
                                          controller: _commentController,
                                          readOnly: true,
                                          maxLines: 4,
                                          icon: Icons.description,
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text("No data available");
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
