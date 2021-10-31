import 'package:flutter/material.dart';

class SubmitButtonWidget extends StatefulWidget {
  final Function onPressed;
  final String displayButtonText;

  const SubmitButtonWidget(
      {Key? key, required this.onPressed, required this.displayButtonText})
      : super(key: key);

  @override
  _SubmitButtonWidgetState createState() => _SubmitButtonWidgetState();
}

class _SubmitButtonWidgetState extends State<SubmitButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      minWidth: MediaQuery.of(context).size.width,
      onPressed: () => widget.onPressed(),
      child: Text(widget.displayButtonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 2.0)),
    );
  }
}
