import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  final String title;
  final String positiveText;
  final VoidCallback onPositivePressed;
  final String negativeText;
  final VoidCallback onNegativePressed;
  final String content;

  const YesNoDialog(
    this.title,
    this.content,
    this.positiveText,
    this.onPositivePressed,
    this.negativeText,
    this.onNegativePressed, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ))),
                  onPressed: onPositivePressed,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: Text(
                      positiveText,
                      style: TextStyle(
                          color: Color(0xff515C6F),
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ))),
                  onPressed: onNegativePressed,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: Text(
                      negativeText,
                      style: TextStyle(
                          color: Color(0xff515C6F),
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
