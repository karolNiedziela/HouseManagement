import 'package:flutter/material.dart';
import 'package:housemanagement/shared/shared_styles.dart';

class NameTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData iconData;

  const NameTextFormFieldWidget(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.iconData = Icons.person_sharp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          autofocus: false,
          controller: controller,
          keyboardType: TextInputType.name,
          validator: (value) {
            if (value!.isEmpty) {
              return "Wprowadź ${hintText.toLowerCase()}.";
            }

            return null;
          },
          onSaved: (value) {
            controller.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: getInputDecoration(iconData, hintText)),
    );
  }
}
