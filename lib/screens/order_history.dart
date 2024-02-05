import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';
import 'package:order_tracker/order_tracker.dart';
import 'package:intl/intl.dart';
import 'package:watch_shop/screens/orderconfirmed_screen.dart';
import 'package:watch_shop/screens/view_product.dart';

class OrderHistory extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final String docId;
  const OrderHistory(
      {super.key, required this.documentSnapshot, required this.docId});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.documentSnapshot['ordertime']));

    final datetime = TimeOfDay.fromDateTime(date).format(context);

    // Order date
    dateTime(DateTime date, int num) {
      var newDate = date;
      if (num == 0) {
        newDate = date;
      } else if (num == 1) {
        newDate = date.add(Duration(days: 2));
      } else if (num == 2) {
        newDate = date.add(Duration(days: 4));
      } else if (num == 3) {
        newDate = date.add(Duration(days: 7));
      }
      final day = newDate.day;
      final month = DateFormat.MMM().format(newDate);
      final year = newDate.year;
      return '${day} ${month} ${year}';
    }

    print(date.add(Duration(days: 30)));
    List<TextDto> orderList = [
      TextDto("Your order has been placed ${dateTime(date, 0)}",
          "${dateTime(date, 0)}, ${datetime}"),
    ];

    List<TextDto> shippedList = [
      TextDto("Your order will be shipped", '${dateTime(date, 1)}'),
    ];

    List<TextDto> outOfDeliveryList = [
      TextDto("Your order will out for delivery", "${dateTime(date, 2)}"),
    ];

    List<TextDto> deliveredList = [
      TextDto("Your order will deliver within a week", '${dateTime(date, 3)}'),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().white,
        leading: BackButton(color: AppColor().black),
        title: Text(
          "Order History",
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
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: mq.width * 0.3,
                  child: Image.network(widget.documentSnapshot['img'])),
              SizedBox(
                width: mq.width * 0.01,
              ),
              SizedBox(
                width: mq.width * .6,
                height: mq.height * 0.18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.documentSnapshot['brand'],
                      style:
                          TextStyle(color: AppColor().lightgrey, fontSize: 16),
                    ),
                    Text(
                      widget.documentSnapshot['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: AppColor().black),
                    ),
                    Text(
                      'QTY: ${widget.documentSnapshot['qty']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: AppColor().black),
                    ),
                    Text(
                      widget.documentSnapshot['price'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: AppColor().black),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.all(mq.width * 0.1),
            child: OrderTracker(
              status: Status.order,
              activeColor: AppColor().green,
              inActiveColor: AppColor().lightgrey,
              orderTitleAndDateList: orderList,
              shippedTitleAndDateList: shippedList,
              outOfDeliveryTitleAndDateList: outOfDeliveryList,
              deliveredTitleAndDateList: deliveredList,
              headingDateTextStyle: TextStyle(color: AppColor().white),
              subDateTextStyle: TextStyle(color: AppColor().lightgrey),
            ),
          ), // PROCEED TO PAYMENT BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: mq.height * .055,
                width: mq.width * 0.4,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: AppColor().white),
                    onPressed: () async {
                      await Apis.cancelorder(widget.docId).then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const OrderConfirmedScreen(
                                      msg: 'Order Cancelled',
                                    )));
                      });
                    },
                    child: Text('Cancel Order',
                        style:
                            TextStyle(color: Color(0xff0a0200), fontSize: 18))),
              ),
              SizedBox(
                height: mq.height * .055,
                width: mq.width * 0.4,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: AppColor().NewgoldBrown),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewProductDetail(
                                  documentSnapshot: widget.documentSnapshot,
                                  docId: widget.docId)));
                    },
                    child: Text('Buy Again',
                        style:
                            TextStyle(color: Color(0xff0a0200), fontSize: 18))),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
