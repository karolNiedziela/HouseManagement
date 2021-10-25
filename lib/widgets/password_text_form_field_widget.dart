import 'package:flutter/material.dart';
import 'package:housemanagement/constants/app_constants.dart';

class PasswordTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const PasswordTextFormFieldWidget(
      {Key? key, required this.controller, this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          autofocus: false,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return ('Please enter password');
            }

            RegExp regex = new RegExp(r'^.{6,}$');
            if (!regex.hasMatch(value)) {
              return ("Please enter a valid password (min. 6 characters)");
            }

            return null;
          },
          onSaved: (value) {
            controller.text = value!;
          },
          obscureText: true,
          textInputAction: TextInputAction.done,
          decoration: getInputDecoration(
              Icons.lock, hintText != null ? hintText.toString() : 'Password')),
    );
  }
}
