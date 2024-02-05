import 'dart:async';
import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/screens/order_items.dart';

class OrderConfirmedScreen extends StatefulWidget {
  final String msg;
  const OrderConfirmedScreen({super.key, required this.msg});

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen> {
  bool value = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        value = !value;
      });
    }).then((value) {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const OrderItems()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColor().oriGrey,
        child: Center(
          child: value
              ? CircularProgressIndicator(color: AppColor().green)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      // color: AppColor().green,
                      height: value ? 0 : 100,
                      width: value ? 0 : 100,
                      duration: Duration(milliseconds: 2000),
                      curve: Curves.fastOutSlowIn,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/confirmed.png'))),
                    ),
                    Text(
                      widget.msg,
                      style: TextStyle(fontSize: 23),
                    )
                  ],
                ),

          // CircularProgressIndicator(color: AppColor().black
        ),
      ),
    );
  }
}
