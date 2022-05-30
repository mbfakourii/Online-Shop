import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'common_utils.dart';

typedef TapOnItem = void Function(String, int);

class DropDownWithController extends StatefulWidget {
  const DropDownWithController(this.list, this.indexCategoryTreatment,
      {Key? key, this.onTap})
      : super(key: key);
  final List<String> list;
  final TapOnItem? onTap;
  final ValueNotifier<String> indexCategoryTreatment;

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDownWithController> {
  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  late String _currentCity;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = <DropdownMenuItem<String>>[];
    for (String value in widget.list) {
      items.add(DropdownMenuItem(
          value: value,
          child: Text(
            value,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          )));
    }
    return items;
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCity = _dropDownMenuItems[0].value!;

    widget.indexCategoryTreatment.addListener(() {
      changedDropDownItem(widget.indexCategoryTreatment.value);
    });
    super.initState();
  }

  @override
  void dispose() {
    try {
      widget.indexCategoryTreatment.dispose();
    } catch (e) {
      errorShow(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.white,
        child: Center(
            child: DropdownButton(
          underline: Container(),
          value: _currentCity,
          items: _dropDownMenuItems,
          onChanged: changedDropDownItem,
        )));
  }

  void changedDropDownItem(String? selectedCity) {
    if (_currentCity == selectedCity) {
      return;
    }
    setState(() {
      _currentCity = selectedCity!;
    });
    widget.indexCategoryTreatment.value = selectedCity!;
    widget.onTap!(selectedCity, widget.list.indexOf(selectedCity));
  }
}
