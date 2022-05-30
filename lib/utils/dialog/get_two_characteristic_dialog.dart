import 'package:flutter/material.dart';
import 'package:online_shop/utils/common_utils.dart';

import '../label_text_field.dart';

class GetTwoCharacteristicDialog extends StatelessWidget {
  final String title;
  final String content;
  TextEditingController? nameCharacteristic = TextEditingController();
  TextEditingController? textCharacteristic = TextEditingController();

  GetTwoCharacteristicDialog(
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
              LabelTextField(
                "نام مشخصه",
                TextInputType.name,
                myController: nameCharacteristic,
              ),
              LabelTextField(
                "متن مشخصه",
                TextInputType.name,
                myController: textCharacteristic,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    if (validation(nameCharacteristic!.text, context)) {
                      return;
                    }

                    if (validation(textCharacteristic!.text, context)) {
                      return;
                    }

                    Navigator.pop(context,
                        [nameCharacteristic!.text, textCharacteristic!.text]);
                  },
                  child: const Text(
                    "تایید",
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "انصراف",
                  )),
            ],
          )
        ],
      ),
    );
  }
}
