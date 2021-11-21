import 'package:flutter/material.dart';
import 'package:housemanagement/widgets/textFormFields/base_text_form_field_widget.dart';

class PersonNameTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputAction textInputAction;

  const PersonNameTextFormFieldWidget(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.textInputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseTextFormFieldWidget(
      controller: controller,
      keyboardType: TextInputType.name,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Wprowadź ${hintText.toLowerCase()}.";
        }

        return null;
      },
      hintText: hintText,
      prefixIcon: Icons.person_sharp,
      textInputAction: textInputAction,
    );
  }
}
