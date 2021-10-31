import 'package:flutter/material.dart';
import 'package:housemanagement/widgets/submit_button_widget.dart';

InputDecoration getInputDecoration(IconData prefixIcon, String hintText) =>
    InputDecoration(
        prefixIcon: Icon(prefixIcon),
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
            borderRadius: BorderRadius.circular(15)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)));

Material getSubmitButton(SubmitButtonWidget submitButtonWidget) => Material(
    elevation: 5,
    borderRadius: BorderRadius.circular(30),
    color: Colors.indigo,
    child: submitButtonWidget);
