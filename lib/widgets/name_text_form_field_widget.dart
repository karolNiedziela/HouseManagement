import 'package:flutter/material.dart';
import 'package:housemanagement/constants/app_constants.dart';

class NameTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const NameTextFormFieldWidget(
      {Key? key, required this.controller, required this.hintText})
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
              return "Please enter ${hintText.toLowerCase()}";
            }

            return null;
          },
          onSaved: (value) {
            controller.text = value!;
          },
          textInputAction: TextInputAction.next,
          decoration: getInputDecoration(Icons.person_sharp, hintText)),
    );
  }
}
