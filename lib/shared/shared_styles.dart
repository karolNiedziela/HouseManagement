import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housemanagement/core/colors.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';

InputDecoration getInputDecoration(IconData prefixIcon, String hintText,
        {int? errorMaxLines}) =>
    InputDecoration(
        prefixIcon: Icon(prefixIcon),
        hintText: hintText,
        errorMaxLines: errorMaxLines,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppColors.primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(15)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)));

Material getSubmitButton(SubmitButtonWidget submitButtonWidget) => Material(
    elevation: 5,
    borderRadius: BorderRadius.circular(30),
    color: AppColors.primaryColor,
    child: submitButtonWidget);

TextFormField getTextFormField(
    TextEditingController textEditingController,
    TextInputType keyboardType,
    String? Function(String?)? validator,
    TextInputAction textInputAction) {
  return TextFormField(
    autofocus: false,
    controller: textEditingController,
    validator: validator,
    onSaved: (value) {
      textEditingController.text = value!;
    },
    keyboardType: keyboardType,
    textInputAction: textInputAction,
  );
}
