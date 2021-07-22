import 'package:flutter/material.dart';
import 'package:go_event_customer/components/loading_snackbar.dart';
import 'package:go_event_customer/components/rounded_button.dart';
import 'package:go_event_customer/components/rounded_input_field.dart';
import 'package:go_event_customer/controllers/event_controller.dart';
import 'package:go_event_customer/models/Event.dart';
import 'package:go_event_customer/popup_dialog.dart';
import 'package:go_event_customer/validator.dart';

class CreateEventForm extends StatelessWidget {
  const CreateEventForm({
    Key key,
    @required GlobalKey<FormState> eventFormKey,
    @required TextEditingController nameController,
    @required TextEditingController budgetController,
    @required this.onCreate,
  })  : _eventFormKey = eventFormKey,
        _nameController = nameController,
        _budgetController = budgetController,
        super(key: key);

  final GlobalKey<FormState> _eventFormKey;
  final TextEditingController _nameController;
  final TextEditingController _budgetController;
  final Function onCreate;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _eventFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Create New Event",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          RoundedInputField(
            hintText: "Event Name",
            controller: _nameController,
            icon: Icons.event,
            validator: Validator.eventNameValidator,
          ),
          RoundedInputField(
            hintText: "Event Budget",
            suffixText: "IDR",
            icon: Icons.money,
            controller: _budgetController,
            digitInput: true,
            isMoney: true,
          ),
          RoundedButton(
              text: "Create Event",
              press: () {
                PopUpDialog.confirmationDialog(
                    context: context,
                    onPressed: () async {
                      if (_eventFormKey.currentState.validate()) {
                        final event = Event(
                          eventName: _nameController.text.trim(),
                          eventBudget: num.parse(
                              _budgetController.text.replaceAll(".", "")),
                        );
                        await setEvent(context, event).then((value) {
                          loadingSnackBar(
                              context: context, text: "Event Created");
                        }).catchError((e) {
                          loadingSnackBar(
                              context: context,
                              text: "an Error Occurred",
                              color: Colors.red);
                        });
                        onCreate();
                      }
                    },
                    title: "Create Event?");
              }),
        ],
      ),
    );
  }
}
