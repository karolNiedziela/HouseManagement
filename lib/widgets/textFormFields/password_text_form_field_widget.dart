import 'package:flutter/material.dart';
import 'package:housemanagement/widgets/textFormFields/base_text_form_field_widget.dart';

class PasswordTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String? hintText;

  const PasswordTextFormFieldWidget(
      {Key? key,
      required this.controller,
      required this.textInputAction,
      this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseTextFormFieldWidget(
      controller: controller,
      hintText: hintText == null ? 'Password' : hintText!,
      prefixIcon: Icons.lock,
      textInputAction: textInputAction,
      validator: (String? value) {
        if (value!.isEmpty) {
          return ('Wprowadź hasło.');
        }

        RegExp regex = RegExp(r'^.{6,}$');
        if (!regex.hasMatch(value)) {
          return ("Wprowadź poprawne hasło(min. 6 znaków).");
        }

        return null;
      },
      obscureText: true,
      keyboardType: TextInputType.text,
    );
  }
}
