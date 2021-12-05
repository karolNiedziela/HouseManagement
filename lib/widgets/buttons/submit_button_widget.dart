import 'package:flutter/material.dart';

class SubmitButtonWidget extends StatefulWidget {
  final Function onPressed;
  final String displayButtonText;
  final BuildContext context;

  const SubmitButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.displayButtonText,
      required this.context})
      : super(key: key);

  @override
  _SubmitButtonWidgetState createState() => _SubmitButtonWidgetState();
}

class _SubmitButtonWidgetState extends State<SubmitButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith((states) {
            return const EdgeInsets.fromLTRB(20, 15, 20, 15);
          }),
        ),
        onPressed: () => widget.onPressed(),
        child: Text(widget.displayButtonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.button!.color,
            )),
      ),
    );
  }
}
