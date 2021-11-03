import 'package:flutter/material.dart';
import 'package:housemanagement/constants/app_constants.dart';

class PasswordTextFormFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;

  const PasswordTextFormFieldWidget(
      {Key? key, required this.controller, this.hintText})
      : super(key: key);

  @override
  State<PasswordTextFormFieldWidget> createState() =>
      _PasswordTextFormFieldWidgetState();
}

class _PasswordTextFormFieldWidgetState
    extends State<PasswordTextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          autofocus: false,
          controller: widget.controller,
          validator: (value) {
            if (value!.isEmpty) {
              return ('Please enter password');
            }

            RegExp regex = RegExp(r'^.{6,}$');
            if (!regex.hasMatch(value)) {
              return ("Please enter a valid password (min. 6 characters)");
            }

            return null;
          },
          onSaved: (value) {
            widget.controller.text = value!;
          },
          obscureText: true,
          textInputAction: TextInputAction.done,
          decoration: getInputDecoration(
              Icons.lock,
              widget.hintText != null
                  ? widget.hintText.toString()
                  : 'Password')),
    );
  }
}
