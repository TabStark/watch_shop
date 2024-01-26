import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:another_flushbar/flushbar.dart';


class DialogsWidget {
  // Snackbar
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
    ));
  }

  // Loader
  static void showProgressBar(BuildContext context, _animationcontroller) {
    showDialog(
      context: context,
      builder: (_) => SpinKitFadingCircle(
        color: AppColor().white,
        size: 50,
        controller: _animationcontroller,
      ),
    );
  }

  static void showFlushBar(BuildContext context, String msg) {
    Flushbar(
      backgroundColor: AppColor().white,
      message: msg,
      messageColor: AppColor().black,
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }

  static void showFlushBarBottom(BuildContext context, String msg) {
    Flushbar(
      backgroundColor: AppColor().white,
      message: msg,
      messageColor: AppColor().black,
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }
}
