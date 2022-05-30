import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import '../main.dart';
import 'constants.dart';
import 'common_utils.dart';
// ignore_for_file: INVALID_USE_OF_PROTECTED_MEMBER

// ErrorLoading(
//  callback: controller,
//  onTry: (value) {
//    print(value);
//  },
//  child: blocback(context, size),
// ))
//

class ELM {
  late bool isVisible;
  late String _type;
  late String _tag;
  late String toast = "";

  String get tag => _tag;

  ELM setTag(String value) {
    _tag = value;
    return this;
  }

  ELM showLoading() {
    _type = "1";
    this.isVisible = true;
    return this;
  }

  ELM hiddenLoading() {
    _type = "111";
    this.isVisible = false;
    return this;
  }

  ELM showErrorWithOutOK(String tag) {
    _type = "22";
    this.isVisible = true;
    this._tag = tag;
    return this;
  }

  ELM showError(String tag) {
    _type = "2";
    this.isVisible = true;
    this._tag = tag;
    return this;
  }

  ELM showErrorToast(String tag, String toast) {
    _type = "2";
    this.isVisible = true;
    this._tag = tag;
    this.toast = toast;
    return this;
  }

  ELM hiddenError() {
    this.isVisible = false;
    return this;
  }

  ELM showProgress() {
    _type = "3";
    this.isVisible = true;
    return this;
  }
}

class Double {
  final double value;

  Double(this.value);
}

class ErrorLoading extends StatefulWidget {
  final ValueNotifier<ELM>? callback;
  final ValueNotifier<Double>? progress;

  final Widget? child;
  final ValueSetter<String>? onTry;
  final bool? firstLoadShowLoading;

  ErrorLoading(BuildContext context,
      {Key? key,
      this.child,
      this.onTry,
      this.firstLoadShowLoading,
      this.callback,
      this.progress})
      : super(key: key) {
    mainContext = context;
  }

  @override
  _ErrorLoadingState createState() => _ErrorLoadingState();
}

class _ErrorLoadingState extends State<ErrorLoading> {
  bool isErrorWithoutOK = false;
  double widthTryError = 0;
  bool isError = false;
  bool isLoading = false;
  bool isProgress = false;
  bool lastVisible = false;
  bool animationError = false;
  bool animationLoading = false;

  String textPercent = "0";
  double showPercent = 0.0;
  ELM? _elm;

  void setViewShow(
      bool isLoading, bool isError, bool isProgress, bool isErrorWithoutOK) {
    if (mounted) {
      setState(() {
        this.animationLoading = isLoading;
        this.isLoading = isLoading;

        this.animationError = isError;
        this.isError = isError;
        this.isErrorWithoutOK = isErrorWithoutOK;

        if (isErrorWithoutOK) {
          widthTryError = MediaQuery.of(context).size.width * 0.71;
        } else {
          widthTryError = MediaQuery.of(context).size.width * 0.34;
        }

        this.isProgress = isProgress;
      });
    }
  }


  void setListeners() {
    try {
      if (widget.progress!.hasListeners == false) {
        widget.progress!.addListener(() {
          if (isProgress) {
            setState(() {
              textPercent =
                  (widget.progress!.value.value * 100).toInt().toString();
              showPercent = widget.progress!.value.value;
            });
          }
        });
      }
    } catch (_) {}

    try {
      if (widget.callback!.hasListeners == false) {
        widget.callback!.addListener(() {
          _elm = widget.callback!.value;
          if (lastVisible || widget.callback!.value.isVisible) {
            setViewShow(false, false, false, false);
          }
          if (widget.callback!.value.isVisible) {
            switch (widget.callback!.value._type) {
              case "1":
                {
                  setViewShow(true, false, false, false);
                  break;
                }
              case "2":
                {
                  setViewShow(false, true, false, false);
                  if (widget.callback!.value.toast != "") {
                    Fluttertoast.showToast(
                        msg: widget.callback!.value.toast,
                        toastLength: Toast.LENGTH_SHORT);
                  }
                  break;
                }

              case "22":
                {
                  setViewShow(false, true, false, true);
                  break;
                }

              case "3":
                {
                  setViewShow(false, false, true, false);
                  break;
                }
            }
          } else {
            setViewShow(false, false, false, false);
          }
          lastVisible = widget.callback!.value.isVisible;
        });
      }
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (widget.firstLoadShowLoading == true) {
        _elm = ELM().showLoading();
        setViewShow(true, false, false, false);
      }
    });

    setListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: AlignmentDirectional.center,
      children: [
        widget.child!,
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: isLoading,
          child: Container(
              decoration: BoxDecoration(color: Color(0xB4636060)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Lottie.asset('assets/lottie/loading.json',
                              animate: animationLoading)))
                ],
              )),
        ),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: isError,
          child: Container(
              decoration: BoxDecoration(color: Color(0xB4636060)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: Lottie.asset(
                            'assets/lottie/error.json',
                            repeat: false,
                            animate: animationError,
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Visibility(
                        visible: !isErrorWithoutOK,
                        child: Flexible(
                          child: Container(
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width * 0.34,
                              child: TextButton(
                                style: ButtonStyle(
                                    elevation: MaterialStateProperty
                                        .resolveWith<double>(
                                      (Set<MaterialState> states) {
                                        return 4;
                                      },
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all(prim),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ))),
                                child: const Text(
                                  "تایید",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  widget.callback!.value =
                                      ELM().hiddenLoading();
                                },
                              )),
                          flex: 2,
                        ),
                      ),
                      Visibility(
                        visible: !isErrorWithoutOK,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                      Flexible(
                        child: Container(
                            color: Colors.transparent,
                            width: widthTryError,
                            child: TextButton(
                              style: ButtonStyle(
                                  elevation:
                                      MaterialStateProperty.resolveWith<double>(
                                    (Set<MaterialState> states) {
                                      return 4;
                                    },
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(prim),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ))),
                              child: const Text(
                                "بررسی مجدد",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                widget.onTry!.call(_elm!._tag);
                                setViewShow(true, false, false, false);
                              },
                            )),
                        flex: 2,
                      ),
                    ],
                  )
                ],
              )),
        ),
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: isProgress,
          child: Container(
              decoration: const BoxDecoration(color: Color(0xB4636060)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: SizedBox(
                          width: percentW(context, 0.80),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.0),
                              ),
                              color: Colors.green,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: percentW(context, 0.05),
                                        right: percentW(context, 0.05),
                                        top: percentH(context, 0.02)),
                                    child: const Text("لطفا شکیبا باشید",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(
                                          percentH(context, 0.01)),
                                      child: Card(
                                        color: Colors.white,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: percentH(context, 0.033),
                                              bottom: percentH(context, 0.03),
                                              left: percentW(context, 0.02),
                                              right: percentW(context, 0.02)),
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                child: Text("%" +
                                                    replaceFarsiNumber(
                                                        textPercent)),
                                                flex: 2,
                                              ),
                                              Flexible(
                                                flex: 14,
                                                child: SizedBox(
                                                    width: double.infinity,
                                                    height: percentH(
                                                        context, 0.015),
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: showPercent,
                                                      backgroundColor:
                                                          const Color(0x808B9E6A),
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Color(
                                                                  0xff6edb6e)),
                                                    )),
                                              ),
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                          ),
                                        ),
                                      )),
                                ],
                              ))))
                ],
              )),
        ),
      ],
    );
  }
}
