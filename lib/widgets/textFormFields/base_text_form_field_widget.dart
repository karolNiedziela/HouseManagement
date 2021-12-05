import 'package:flutter/material.dart';
import 'package:housemanagement/shared/shared_styles.dart';

class BaseTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool autofocus;
  final String hintText;
  final IconData prefixIcon;
  final int? errorMaxLines;

  const BaseTextFormFieldWidget(
      {Key? key,
      required this.controller,
      required this.validator,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.onTap,
      this.readOnly = false,
      this.autofocus = false,
      required this.textInputAction,
      required this.hintText,
      required this.prefixIcon,
      this.errorMaxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
          autofocus: autofocus,
          obscureText: obscureText,
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          onSaved: (value) {
            controller.text = value!;
          },
          textInputAction: textInputAction,
          decoration: getInputDecoration(context, prefixIcon, hintText,
              errorMaxLines: errorMaxLines)),
    );
  }
}
