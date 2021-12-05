import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:housemanagement/widgets/buttons/submit_button_widget.dart';

InputDecoration getInputDecoration(
        BuildContext context, IconData prefixIcon, String hintText,
        {int? errorMaxLines}) =>
    InputDecoration(
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).primaryColor,
        ),
        hintStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
        hintText: hintText,
        errorMaxLines: errorMaxLines,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(15)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)));

Material getSubmitButton(SubmitButtonWidget submitButtonWidget) => Material(
    elevation: 5,
    borderRadius: BorderRadius.circular(30),
    color: Theme.of(submitButtonWidget.context).primaryColor,
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
