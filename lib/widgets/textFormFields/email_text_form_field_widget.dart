import 'package:flutter/material.dart';
import 'package:housemanagement/constants/app_constants.dart';

class EmailTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const EmailTextFormFieldWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
          autofocus: false,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isEmpty) {
              return ('Please enter email');
            }

            // reg expression for email
            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                .hasMatch(value)) {
              return ("Please enter a valid email");
            }
            return null;
          },
          onSaved: (value) {
            controller.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: getInputDecoration(Icons.email, 'Email')),
    );
  }
}
