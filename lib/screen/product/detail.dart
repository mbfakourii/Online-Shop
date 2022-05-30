import 'package:flutter/material.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/model/user.dart';
import 'package:online_shop/repositories/main_req.dart';
import 'package:online_shop/screen/basket/basket.dart';
import 'package:online_shop/utils/common_utils.dart';
import 'package:online_shop/utils/dialog/text_show_dialog.dart';
import 'package:online_shop/utils/error_loading.dart';

class Detail extends StatefulWidget {
  const Detail(this.product, this.user, {Key? key}) : super(key: key);
  final Product product;
  final User user;

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<Widget> properties = <Widget>[];

  ValueNotifier<ELM> callback = ValueNotifier<ELM>(ELM());
  late Product product;
  MainReq mainReq = MainReq();

  @override
  void initState() {
    product = widget.product;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getDetail();
    });



    super.initState();
  }

  void getDetail() async {
    // send data
    callback.value = ELM().showLoading();
    try {
      product = (await mainReq.getProduct(product.name!))!;

      for (var element in product.characteristics!) {
        properties.add(Text(element[0] + " : " + element[1],
            textDirection: TextDirection.rtl,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xff2B2B2B))));
      }

      setState(() {});

      callback.value = ELM().hiddenLoading();
    } catch (e) {
      callback.value = ELM().hiddenLoading();
    }
  }

  Future<void> deleteProduct() async {
    // send data
    callback.value = ELM().showLoading();
    try {
      await mainReq.deleteProduct(widget.user.userName!, product);

      toastShow("کالا با موفقیت حذف شد");
      Navigator.pop(context, true);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => TextShowDialog("خطا", e.toString()));
    }
    callback.value = ELM().hiddenLoading();
  }

  Future<void> addInBasket() async {
    // send data
    callback.value = ELM().showLoading();
    try {
      await mainReq.addInBasket(widget.user.userName!, product);

      toastShow("با موفقیت سبد اضافه شد");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Basket(widget.user)),
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => TextShowDialog("خطا", e.toString()));
    }
    callback.value = ELM().hiddenLoading();
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
            leading: const BackButton(color: Colors.black),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    deleteProduct();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.black,
                  ))
            ],
            title: const Text(
              "نمایش محصول",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff2B2B2B)),
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "نام محصول : " + product.name!,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xff2B2B2B)),
                            ),
                            Text(
                              "نوع محصول : " + product.type!,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xff2B2B2B)),
                            ),
                            Text(
                              "قیمت محصول : " +
                                  product.price!.toString() +
                                  " ریال",
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xff2B2B2B)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: properties.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: properties,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff07c15f)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () async {
                      addInBasket();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      child: Text(
                        "افزودن به سبد خرید",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
          ))),
    );
  }
}
