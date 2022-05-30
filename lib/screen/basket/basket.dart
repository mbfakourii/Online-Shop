import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/model/user.dart';
import 'package:online_shop/repositories/main_req.dart';
import 'package:online_shop/utils/common_utils.dart';
import 'package:online_shop/utils/dialog/text_show_dialog.dart';
import 'package:online_shop/utils/dialog/yes_no_dialog.dart';
import 'package:online_shop/utils/error_loading.dart';

class Basket extends StatefulWidget {
  const Basket(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  ValueNotifier<ELM> callback = ValueNotifier<ELM>(ELM());
  MainReq mainReq = MainReq();
  List<Product>? products = <Product>[];
  bool noItem = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getBasket();
    });
    super.initState();
  }

  void getBasket() async {
    // send data
    callback.value = ELM().showLoading();
    try {
      products = await mainReq.getUserBasket(widget.user.userName!);

      if (products!.isEmpty) {
        setState(() {
          noItem = true;
          priceText = "قیمت نهایی : 0 ریال";
        });
      }
      calculatePrice();
      callback.value = ELM().hiddenLoading();
    } catch (e) {
      setState(() {
        noItem = true;
        priceText = "قیمت نهایی : 0 ریال";
      });
    }
    setState(() {});
    callback.value = ELM().hiddenLoading();
  }

  Future<void> buy() async {
    // send data
    callback.value = ELM().showLoading();
    try {
      await mainReq.buy(widget.user.userName!, products!);
      toastShow("خریداری با موفقیت انجام شد");
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => TextShowDialog("خطا", e.toString()));
    }
    callback.value = ELM().hiddenLoading();
  }

  Future<void> deleteProduct(Product product) async {
    // send data
    callback.value = ELM().showLoading();
    try {
      await mainReq.deleteFromBasket(widget.user.userName!, product);
      calculatePrice();
      toastShow("کالا با موفقیت از سبد شما حذف شد");
      getBasket();
    } catch (e) {
      errorShow(e);
      setState(() {
        noItem = true;
      });
    }
    callback.value = ELM().hiddenLoading();
  }

  void calculatePrice() {
    try {
      int price2 = 0;
      for (int i = 0; i < products!.length; i++) {
        price2 = price2 + products![i].price!;
      }

      price = price2;
      priceText = "قیمت نهایی : " + price2.toString() + " ریال";
    } catch (e) {
      priceText = "قیمت نهایی : 0 ریال";
      price = 0;
    }

    setState(() {});
  }

  String priceText = "";
  int price = 0;

  @override
  Widget build(BuildContext context) {
    return ErrorLoading(context, callback: callback, onTry: (value) {
      if (value == "1") {}
    },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: const BackButton(color: Colors.black),
              centerTitle: true,
              title: const Text(
                "سبد خرید",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff2B2B2B)),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: noItem == true
                      ? const Center(
                          child: Text("چیزی یافت نشد !",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 17)))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: products!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: TextButton(
                                            style: ButtonStyle(
                                                elevation: MaterialStateProperty
                                                    .resolveWith<double>(
                                                  (Set<MaterialState> states) {
                                                    return 4;
                                                  },
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        const Color(
                                                            0xffffffff)),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ))),
                                            onPressed: () {
                                              deleteProduct(products![index]);
                                            },
                                            child: const SizedBox(
                                                child: Icon(
                                              Icons.delete,
                                              size: 15,
                                            ))),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              products![index].name!,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Color(0xff2B2B2B)),
                                            ),
                                            Text(
                                              "قیمت : " +
                                                  products![index]
                                                      .price!
                                                      .toString() +
                                                  " ریال",
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Color(0xff2B2B2B)),
                                            ),
                                            Text(
                                              "نوع : " +
                                                  products![index]
                                                      .type!
                                                      .toString(),
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Color(0xff2B2B2B)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Expanded(
                    flex: 1,
                    child: Card(
                        elevation: 14,
                        child: Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Expanded(
                                flex: 10,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    priceText,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color(0xff2B2B2B)),
                                  ),
                                )),
                            Expanded(
                                flex: 7,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xff07c15f)),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ))),
                                      onPressed: () async {
                                        if (price == 0) {
                                          toastShow("سبد خرید خالی است !");
                                          return;
                                        }

                                        showDialog(
                                            context: context,
                                            builder: (context) => YesNoDialog(
                                                "خرد",
                                                "آیا نهایی سازی خرید انجام شود ؟",
                                                "بله",
                                                () async {
                                                  Navigator.pop(context, true);
                                                  buy();
                                                },
                                                "خیر",
                                                () {
                                                  Navigator.pop(context, false);
                                                  return;
                                                }));
                                      },
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.only(right: 5, left: 5),
                                        child: Text(
                                          "نهایی سازی خرید",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      )),
                                )),
                          ],
                        )))
              ],
            )));
  }
}
