import 'package:flutter/material.dart';
import 'package:online_shop/model/order.dart';
import 'package:online_shop/model/user.dart';
import 'package:online_shop/repositories/main_req.dart';
import 'package:online_shop/utils/common_utils.dart';
import 'package:online_shop/utils/dialog/text_show_dialog.dart';
import 'package:online_shop/utils/error_loading.dart';
import 'package:shamsi_date/extensions.dart';

class Orders extends StatefulWidget {
  const Orders(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  ValueNotifier<ELM> callback = ValueNotifier<ELM>(ELM());
  MainReq mainReq = MainReq();
  List<Order>? orders = <Order>[];
  bool noItem = false;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getOrders();
    });
    super.initState();
  }

  void getOrders() async {
    // send data
    callback.value = ELM().showLoading();
    try {
      orders = await mainReq.getOrders(widget.user.userName!);


      callback.value = ELM().hiddenLoading();
      if (orders != null) {
        if (orders!.isEmpty) {
          setState(() {
            noItem = true;
          });
        } else {
          setState(() {});
        }
      }else{
        setState(() {
          noItem = true;
        });
      }
    } catch (e) {
      setState(() {
        noItem = true;
      });
    }
    callback.value = ELM().hiddenLoading();
  }

  int price = 0;

  @override
  Widget build(BuildContext context) {
    return ErrorLoading(context, callback: callback, onTry: (value) {
      if (value == "1") {}
    },
        child: Scaffold(
            backgroundColor: Color(0xffececec),
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: const BackButton(color: Colors.black),
              centerTitle: true,
              title: const Text(
                "سفارش های من",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xff2B2B2B)),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: noItem == true
                ? const Center(
                    child: Text("چیزی یافت نشد !",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 17)))
                : ListView.builder(
                    itemCount: orders!.length,
                    itemBuilder: (context, index) {
                      price = 0;
                      for (int i = 0; i < orders![index].product!.length; i++) {
                        price = price + orders![index].product![i].price!;
                      }
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        "اجناس خریداری شده : ",
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color(0xff2B2B2B)),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            orders![index].product!.length,
                                        itemBuilder: (context, index2) {
                                          return Column(
                                            children: [
                                              Text(
                                                orders![index]
                                                    .product![index2]
                                                    .name!,
                                                textDirection:
                                                    TextDirection.rtl,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Color(0xff2B2B2B)),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "قیمت : " +
                                                    orders![index]
                                                        .product![index2]
                                                        .price!
                                                        .toString() +
                                                    " ریال",
                                                textDirection:
                                                    TextDirection.rtl,
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Color(0xff2B2B2B)),
                                              ),
                                              Visibility(
                                                visible: index2 !=
                                                    orders![index]
                                                            .product!
                                                            .length -
                                                        1,
                                                child: const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25, right: 25),
                                                  child: Divider(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      const Divider(color: Colors.black),
                                      Text(
                                        "وضعیت : " + orders![index].status!,
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color(0xff2B2B2B)),
                                      ),
                                      Text(
                                        "تاریخ خرید : " +
                                            convertDateToJalali(Jalali
                                                .fromDateTime(DateTime.parse(
                                                    orders![index].dateTime!))),
                                        textDirection: TextDirection.rtl,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color(0xff2B2B2B)),
                                      ),
                                      Text(
                                        "قیمت کل : " + price.toString(),
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
                  )));
  }
}
