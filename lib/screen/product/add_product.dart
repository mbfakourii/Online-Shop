import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/model/user.dart';
import 'package:online_shop/repositories/main_req.dart';
import 'package:online_shop/screen/home/home.dart';
import 'package:online_shop/utils/common_utils.dart';
import 'package:online_shop/utils/dialog/get_two_characteristic_dialog.dart';
import 'package:online_shop/utils/dialog/text_show_dialog.dart';
import 'package:online_shop/utils/drop_down_with_controller.dart';
import 'package:online_shop/utils/error_loading.dart';
import 'package:online_shop/utils/label_text_field.dart';

class AddProduct extends StatefulWidget {
  const AddProduct(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController? productName = TextEditingController();
  TextEditingController? numberProduct = TextEditingController();
  TextEditingController? priceProduct = TextEditingController();
  ValueNotifier<String> indexCategoryTreatment =
      ValueNotifier<String>(listMainType[0]);
  ValueNotifier<ELM> callback = ValueNotifier<ELM>(ELM());
  List<Widget> listCharacteristic = <Widget>[];
  List<List<String>> listCharacteristicContent = <List<String>>[];
  MainReq mainReq = MainReq();

  List<String> listCate = <String>[""];

  @override
  void initState() {
    listCate = listMainType;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ErrorLoading(
      context,
      callback: callback,
      onTry: (value) {
        if (value == "1") {}
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: const BackButton(color: Colors.black),
            title: const Text(
              "اضافه کردن کالا",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff2B2B2B)),
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
              child: Column(
            children: [
              LabelTextField(
                "نام کالا",
                TextInputType.name,
                myController: productName,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
                      "نوع کالا",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xff2B2B2B)),
                    ),
                    Expanded(
                      flex: 8,
                      child: DropDownWithController(
                        listCate,
                        indexCategoryTreatment,
                        onTap: (value, index) {},
                      ),
                    ),
                  ],
                ),
              ),
              LabelTextField(
                "تعداد موجودی کالا",
                TextInputType.number,
                myController: numberProduct,
              ),
              LabelTextField(
                "قیمت کالا (ریال)",
                TextInputType.number,
                myController: priceProduct,
              ),
              const Divider(thickness: 0.1, color: Colors.black),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Text(
                      "مشخصه جدید",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xff2B2B2B)),
                    ),
                    const Expanded(child: SizedBox()),
                    TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xffaf43d7)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          List<String>? list = await showDialog(
                              context: context,
                              builder: (context) => GetTwoCharacteristicDialog(
                                  "اضافه کردن مشخصه جدید",
                                  "تمام پارامتر های را پر کنید"));

                          if (list != null) {
                            listCharacteristicContent.add(list);
                            listCharacteristic.add(
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          list[0],
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                        )),
                                        const Text("|"),
                                        Expanded(
                                            child: Text(
                                          list[1],
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5, left: 5),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: const [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                "اضافه مشخصه جدید",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Column(children: listCharacteristic),
              const Divider(thickness: 0.1, color: Colors.black),
              SizedBox(
                width: percentW(context, 0.50),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff00c259)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () async {
                      if (validation(productName!.text, context)) {
                        return;
                      }

                      if (validation(numberProduct!.text, context)) {
                        return;
                      }
                      if (validation(priceProduct!.text, context)) {
                        return;
                      }

                      // send data
                      bool? user;
                      try {
                        callback.value = ELM().showLoading();
                        user = await mainReq.addProduct(
                            productName!.text,
                            indexCategoryTreatment.value,
                            int.parse(numberProduct!.text),
                            int.parse(priceProduct!.text),
                            listCharacteristicContent);
                        callback.value = ELM().hiddenLoading();
                      } catch (e) {
                        callback.value = ELM().hiddenLoading();
                        return;
                      }
                      if (user == false) {
                        showDialog(
                            context: context,
                            builder: (context) => const TextShowDialog(
                                "توجه", "این کالا قبلا اضافه شده !"));
                      } else {
                        refreshHome.value = true;
                        toastShow("با موفقیت اضافه شد");
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      child: Text(
                        "اضافه کردن",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            ],
          ))),
    );
  }
}
