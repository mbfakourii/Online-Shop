import 'package:flutter/material.dart';
import 'package:online_shop/main.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/model/user.dart';
import 'package:online_shop/repositories/main_req.dart';
import 'package:online_shop/screen/basket/basket.dart';
import 'package:online_shop/screen/product/detail.dart';
import 'package:online_shop/screen/profile/profile.dart';
import 'package:online_shop/utils/common_utils.dart';
import 'package:online_shop/utils/dialog/text_show_dialog.dart';
import 'package:online_shop/utils/drop_down_with_controller.dart';
import 'package:online_shop/utils/error_loading.dart';

class Home extends StatefulWidget {
  Home(this.user, {Key? key}) : super(key: key);
  User user;

  @override
  _HomeState createState() => _HomeState();
}

ValueNotifier<bool> refreshHome = ValueNotifier<bool>(false);

class _HomeState extends State<Home> {
  ValueNotifier<ELM> callback = ValueNotifier<ELM>(ELM());
  MainReq mainReq = MainReq();
  TextEditingController? searchControl = TextEditingController(text: "");

  List<String> listPrice = <String>[];
  ValueNotifier<String> indexPrice = ValueNotifier<String>("بدون فیلتر");

  List<String> listType = <String>[];
  ValueNotifier<String> indexType = ValueNotifier<String>("همه");

  List<Product> listProducts = <Product>[];
  List<Product> listProductsConst = <Product>[];

  @override
  void initState() {
    listPrice.add("بدون فیلتر");
    listPrice.add("بیشترین");
    listPrice.add("کم ترین");

    listType.add("همه");
    listType.addAll(listMainType);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getMain();
    });

    refreshHome.addListener(() {
      if (refreshHome.value) {
        getMain();
      }
      refreshHome.value = false;
    });

    super.initState();
  }

  Future<void> getMain() async {
    try {
      FocusScope.of(context).unfocus();
    } catch (e) {
      errorShow(e);
    }
    callback.value = ELM().showLoading();
    List<Product>? products;
    try {
      products = await mainReq.getProducts(searchControl!.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => const TextShowDialog("خطا", "خطا در اتصال !"));
    }
    callback.value = ELM().hiddenLoading();
    if (products != null) {
      listProducts.clear();
      listProducts.addAll(products);

      listProductsConst.clear();
      listProductsConst.addAll(products);
      sortPrice(true);
      if (mounted) {
        setState(() {});
      }
    }
  }

  void selectType() {
    listProducts = listProductsConst;
    if (indexType.value != "همه") {
      listProducts = listProducts.where((element) {
        return element.type == indexType.value;
      }).toList();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void sortPrice(bool fromGetMain) {
    if (indexPrice.value == listPrice[2]) {
      listProducts.sort((a, b) => a.price!.compareTo(b.price!));
    } else if (indexPrice.value == listPrice[1]) {
      listProducts.sort((a, b) => b.price!.compareTo(a.price!));
    } else if (indexPrice.value == listPrice[0]) {
      if (fromGetMain == false) {
        listProducts = listProductsConst;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ErrorLoading(context, callback: callback, onTry: (value) {
      if (value == "1") {}
    },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                "فروشگاه اینترنتی",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0xff2B2B2B)),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile(widget.user)),
                              );

                              getMain();
                            },
                            child: Text(
                              widget.user.firstName! +
                                  " " +
                                  widget.user.lastName!,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Basket(widget.user)),
                            );
                          },
                          icon: const Icon(Icons.shopping_basket)),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 8, top: 0),
                          child: Card(
                            color: const Color(0xffF1F1F1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(124.0),
                            ),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ListTile(
                                leading: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Color(0xff89909B),
                                  ),
                                  onPressed: () {
                                    getMain();
                                  },
                                ),
                                title: TextField(
                                  controller: searchControl,
                                  decoration: const InputDecoration(
                                      hintText: "جستجو",
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text("قیمت"),
                            DropDownWithController(
                              listPrice,
                              indexPrice,
                              onTap: (value, index) {
                                sortPrice(false);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const Text("نوع"),
                            DropDownWithController(
                              listType,
                              indexType,
                              onTap: (value, index) {
                                selectType();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.1, color: Colors.black),
                  listProducts.isEmpty
                      ? const Center(
                          child: Text("چیزی یافت نشد !",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 17)))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: listProducts.length,
                          itemBuilder: (context, index) {
                            return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () async {
                                    bool? delete = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Detail(
                                              listProducts[index],
                                              widget.user)),
                                    );

                                    if (delete != null) {
                                      getMain();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Expanded(child: SizedBox()),
                                            Text(
                                              listProducts[index].name!,
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Expanded(child: SizedBox()),
                                            Text(
                                              "قیمت : " +
                                                  listProducts[index]
                                                      .price!
                                                      .toString() +
                                                  " ریال",
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Expanded(child: SizedBox()),
                                            Text(
                                              "نوع : " +
                                                  listProducts[index]
                                                      .type!
                                                      .toString(),
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          })
                ],
              ),
            ))));
  }
}
