import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';
import 'package:watch_shop/screens/payment_screen.dart';

class BuyNow extends StatefulWidget {
  final String docId;
  final DocumentSnapshot documentSnapshot;
  const BuyNow(
      {super.key, required this.docId, required this.documentSnapshot});

  @override
  State<BuyNow> createState() => _BuyNowState();
}

class _BuyNowState extends State<BuyNow> {
  bool addressbool = true;
  TextEditingController _addressController = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _addressController.text = Apis.me.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().white,
        leading: BackButton(color: AppColor().black),
        title: Text(
          "Order",
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
      body: Form(
        key: _form,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      height: mq.height * 0.16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.documentSnapshot['brand'],
                            style: TextStyle(
                                color: AppColor().lightgrey, fontSize: 16),
                          ),
                          Text(
                            widget.documentSnapshot['name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, color: AppColor().black),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Divider(),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        Text(
                          'Order Details:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),

                        // BRAND
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: mq.width * 0.35,
                              child: Text('Brand : ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Text(widget.documentSnapshot['brand'],
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),

                        // PRODUCT NAME
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Product Name : ',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500)),
                            SizedBox(
                              height: mq.height * 0.07,
                              width: mq.width * 0.5,
                              child: Text(widget.documentSnapshot['name'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),

                        // QTY
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: mq.width * 0.35,
                              child: Text('QTY : ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Text(
                                (widget.documentSnapshot.data()
                                                as Map<String, dynamic>?)
                                            ?.containsKey('qty') ??
                                        false
                                    ? widget.documentSnapshot['qty'].toString()
                                    : '1',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),

                        // PRICE
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: mq.width * 0.35,
                              child: Text('Price : ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Text(widget.documentSnapshot['price'],
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),

                        SizedBox(
                          height: mq.height * 0.03,
                        ),
                        Text(
                          'Shipping Address',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        // ADDRESS FIELD
                        TextFormField(
                          controller: _addressController,
                          onSaved: (val) => Apis.me.address = val ?? "",
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required Field';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                          readOnly: addressbool,
                          // initialValue: Apis.me.address,
                          autofocus: true,
                          decoration: InputDecoration(
                              labelText: 'Your Address',
                              hintText: 'Enter  Address',
                              labelStyle: TextStyle(fontSize: 20),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      addressbool = !addressbool;
                                    });
                                  },
                                  icon: const Icon(Icons.edit))),
                        ),
                        SizedBox(height: mq.height * .05),

                        // PROCEED TO PAYMENT BUTTONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: mq.height * .055,
                              width: mq.width * 0.37,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      backgroundColor: AppColor().white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel',
                                      style: TextStyle(
                                          color: Color(0xff0a0200),
                                          fontSize: 18))),
                            ),
                            SizedBox(
                              height: mq.height * .055,
                              width: mq.width * 0.37,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      backgroundColor: AppColor().NewgoldBrown),
                                  onPressed: () async {
                                    if (_form.currentState!.validate()) {
                                      _form.currentState!.save();
                                      await Apis.updateuserinfo().then((value) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentScreen(
                                                        docId: widget.docId,
                                                        documentSnapshot: widget
                                                            .documentSnapshot)));
                                      });
                                    }
                                  },
                                  child: Text('Confirm',
                                      style: TextStyle(
                                          color: Color(0xff0a0200),
                                          fontSize: 18))),
                            ),
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
