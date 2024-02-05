import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';
import 'package:watch_shop/screens/orderconfirmed_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String docId;
  final DocumentSnapshot documentSnapshot;
  const PaymentScreen(
      {super.key, required this.docId, required this.documentSnapshot});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

enum radiobutton { cash_on_deleviry }

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    radiobutton? _radiobtn = radiobutton.cash_on_deleviry;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().white,
        leading: BackButton(color: AppColor().black),
        title: Text(
          'Confirm Order',
          style: TextStyle(color: AppColor().black),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                size: 30,
                color: AppColor().black,
              ))
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(
            left: mq.width * .05,
            right: mq.width * .05,
            bottom: mq.height * .04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pay On',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: mq.height * 0.02,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: mq.width * 0.03),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: null,
                  child: const ListTile(
                    leading: Icon(Icons.circle_outlined),
                    title: Text('Credit or Debit Card'),
                    trailing: Icon(Icons.credit_card),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: mq.width * 0.03),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: null,
                  child: const ListTile(
                    leading: Icon(Icons.circle_outlined),
                    title: Text('UPI Payment'),
                    subtitle: Text('Google Pay, Paytm and more'),
                    trailing: Icon(Icons.paypal_outlined),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: mq.width * 0.03),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: null,
                  child: const ListTile(
                    leading: Icon(Icons.circle_outlined),
                    title: Text('EMI'),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: mq.width * 0.03),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: null,
                  child: const ListTile(
                    leading: Icon(Icons.circle_outlined),
                    title: Text('Net Banking'),
                    trailing: Icon(Icons.account_balance_outlined),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: () {},
                  child: ListTile(
                    leading: Transform.scale(
                      scale: 1.2,
                      child: Radio(
                        value: radiobutton.cash_on_deleviry,
                        groupValue: _radiobtn,
                        onChanged: (value) {},
                      ),
                    ),
                    title: Text('Cash on Delivery'),
                    trailing: Icon(Icons.money),
                  ),
                )
              ],
            ),
            // PROCEED TO Confirm Order Button

            SizedBox(
              height: mq.height * .055,
              width: mq.width * 1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: AppColor().NewgoldBrown),
                  onPressed: () async {
                    await Apis.OrderItem(widget.docId, widget.documentSnapshot)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>  OrderConfirmedScreen(msg: 'Order Confirmed',)));
                    });
                  },
                  child: Text('Confirm your Order',
                      style:
                          TextStyle(color: Color(0xff0a0200), fontSize: 18))),
            ),
          ],
        ),
      ),
    );
  }
}
