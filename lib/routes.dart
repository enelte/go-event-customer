import 'package:flutter/material.dart';
import 'package:go_event_customer/Screens/Home/home_screen.dart';
import 'package:go_event_customer/Screens/Login/login_screen.dart';
import 'package:go_event_customer/Screens/Profile/profile_screen.dart';
import 'package:go_event_customer/Screens/Service/service_screen.dart';
import 'package:go_event_customer/Screens/ServiceDetails/components/service_gallery.dart';
import 'package:go_event_customer/Screens/ServiceDetails/service_details.dart';
import 'package:go_event_customer/Screens/Signup/signup_screen.dart';
import 'package:go_event_customer/Screens/Welcome/welcome_screen.dart';
import 'package:go_event_customer/screens/CreateTransaction/create_transaction.dart';
import 'package:go_event_customer/screens/EditTransaction/edit_transaction.dart';
import 'package:go_event_customer/screens/Event/event_screen.dart';
import 'package:go_event_customer/screens/EventDetails/event_details.dart';
import 'package:go_event_customer/screens/Review/review.dart';
import 'package:go_event_customer/screens/ServiceDetails/components/service_reviews.dart';
import 'package:go_event_customer/screens/Transaction/transaction_screen.dart';
import 'package:go_event_customer/screens/ProofOfPaymentDetails/proof_of_payment.dart';
import 'package:go_event_customer/screens/TransactionDetails/components/proof_of_payments_list.dart';
import 'package:go_event_customer/screens/TransactionDetails/transaction_details.dart';

class Routes {
  Routes._(); //this is to prevent anyone from instantiate this object

  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String service = '/service';
  static const String service_details = '/service_details';
  static const String service_gallery = '/service_details/gallery';
  static const String service_reviews = '/service_details/reviews';
  static const String profile = '/profile';
  static const String event = '/event';
  static const String event_details = '/event_details';
  static const String create_transaction = '/create_transaction';
  static const String transaction = '/transaction';
  static const String transaction_details = '/transaction_details';
  static const String edit_transaction = '/transaction_details/edit';
  static const String proof_of_payments =
      '/transaction_details/proof_of_payments';
  static const String proof_of_payments_details =
      '/transaction_details/proof_of_payments/details';
  static const String review = '/review';

  static final routes = <String, WidgetBuilder>{
    welcome: (BuildContext context) => WelcomeScreen(),
    login: (BuildContext context) => LoginScreen(),
    signup: (BuildContext context) => SignUpScreen(),
    home: (BuildContext context) => HomeScreen(),
    service: (BuildContext context) => ServiceScreen(),
    service_details: (BuildContext context) => ServiceDetailsScreen(),
    service_gallery: (BuildContext context) => ServiceGallery(),
    service_reviews: (BuildContext context) => ServiceReview(),
    profile: (BuildContext context) => ProfileScreen(),
    event: (BuildContext context) => EventScreen(),
    event_details: (BuildContext context) => EventDetailsScreen(),
    create_transaction: (BuildContext context) => CreateTransactionScreen(),
    transaction: (BuildContext context) => TransactionScreen(),
    transaction_details: (BuildContext context) => TransactionDetailsScreen(),
    edit_transaction: (BuildContext context) => EditTransactionScreen(),
    proof_of_payments: (BuildContext context) => ProofOfPaymentListScreen(),
    proof_of_payments_details: (BuildContext context) => ProofOfPaymentScreen(),
    review: (BuildContext context) => ReviewScreen(),
  };
}
