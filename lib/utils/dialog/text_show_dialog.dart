import 'package:flutter/material.dart';

class TextShowDialog extends StatelessWidget {
  final String title;
  final String content;

  const TextShowDialog(
    this.title,
    this.content, {
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
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "تایید",
                  )),
            ],
          )
        ],
      ),
    );
  }
}
