import 'package:flutter/material.dart';
import 'package:housemanagement/constants/app_constants.dart';

class PositiveNumberTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData iconData;
  const PositiveNumberTextFormFieldWidget(
      {Key? key,
      required this.controller,
      required this.hintText,
      this.iconData = Icons.shopping_basket})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          autofocus: false,
          controller: controller,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter ${hintText.toLowerCase()}";
            }

            if (int.parse(value) <= 0) {
              return "Please enter positive number";
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
