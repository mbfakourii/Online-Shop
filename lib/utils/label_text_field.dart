import 'package:flutter/material.dart';

class LabelTextField extends StatelessWidget {
  LabelTextField(this.text, this.keyboardType,
      {Key? key,
      this.maxLines,
      this.myController,
      this.enabled,
      this.onChanged,
      this.textDirection = TextDirection.rtl,
      this.textAlign})
      : super(key: key);
  String text;
  TextInputType? keyboardType;
  int? maxLines;
  bool? enabled;
  TextEditingController? myController;
  ValueChanged<String>? onChanged;
  TextAlign? textAlign;

  TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Text(
            text,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xff2B2B2B)),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, right: 5.0, bottom: 10.0),
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(25.0),
                child: TextFormField(
                  textAlign: textAlign == null ? TextAlign.start : textAlign!,
                  enabled: enabled,
                  textDirection: textDirection,
                  controller: myController,
                  style: const TextStyle(fontSize: 17, color: Colors.green),
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff8F8F8F)),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
