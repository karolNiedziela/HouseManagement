import 'package:flutter/material.dart';
import 'package:housemanagement/shared/shared_styles.dart';

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
              return ('Wprowadź adres email.');
            }

            // reg expression for email
            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                .hasMatch(value)) {
              return ("Wprowadź poprawny adres email.");
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
