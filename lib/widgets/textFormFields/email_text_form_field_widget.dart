import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:housemanagement/validators/email_validator.dart';
import 'package:housemanagement/widgets/textFormFields/base_text_form_field_widget.dart';

class EmailTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;

  const EmailTextFormFieldWidget({
    Key? key,
    required this.controller,
    required this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseTextFormFieldWidget(
        controller: controller,
        hintText: 'Email',
        prefixIcon: Icons.email,
        keyboardType: TextInputType.emailAddress,
        textInputAction: textInputAction,
        validator: (String? value) {
          return EmailValidator.baseEmailValidator(value);
        });
  }
}
