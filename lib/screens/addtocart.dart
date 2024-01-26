import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';
import 'package:watch_shop/popup%20and%20loader/dialogs.dart';
import 'package:watch_shop/screens/view_product.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({
    super.key,
  });

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> with TickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();

  // Loading Animation
  late final AnimationController _controller =
      AnimationController(duration: Duration(seconds: 3), vsync: this)
        ..repeat();
  // for search
  bool search = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().white,
        leading: BackButton(color: AppColor().black),
        title: Text(
          "Add to Cart",
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
        width: double.infinity,
        height: double.infinity,
        color: AppColor().white,
        child: StreamBuilder(
            stream: Apis.fetchstream('users', Apis.user.uid, 'myaddtocart')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
              if (!snapShot.hasData) {
                return GridView.builder(
                    itemCount: 20,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: .6),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: mq.height * 0.22,
                                color: AppColor().white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: mq.height * 0.01,
                                      color: AppColor().white,
                                    ),
                                    SizedBox(
                                      height: mq.height * .01,
                                    ),
                                    Container(
                                      height: mq.height * 0.01,
                                      color: AppColor().white,
                                    ),
                                    SizedBox(
                                      height: mq.height * .01,
                                    ),
                                    Container(
                                      height: mq.height * 0.01,
                                      color: AppColor().white,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: snapShot.data!.docs.length,
                      itemBuilder: (context, index) {
                        print(
                          snapShot.data!.docs.length,
                        );
                        final data = snapShot.data!.docs;
                        // To take a json
                        // print("Data : ${jsonEncode(data[0].data())}");
                        final DocumentSnapshot documentSnapshot =
                            snapShot.data!.docs[index];
                        final String docid =
                            snapShot.data!.docs[index].reference.id;
                        final String addtocartdoc = docid;
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewProductDetail(
                                          documentSnapshot: documentSnapshot,
                                          docId: addtocartdoc,
                                        )));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: mq.width * 0.3,
                                        child: Image.network(
                                            documentSnapshot['img'])),
                                    SizedBox(
                                      width: mq.width * .6,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            documentSnapshot['brand'],
                                            style: TextStyle(
                                                color: AppColor().lightgrey,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            documentSnapshot['name'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: AppColor().black),
                                          ),
                                          Text(documentSnapshot['price'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColor().black))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: mq.width * 3,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: mq.width * .1,
                                          height: mq.height * .03,
                                          child: (documentSnapshot['qty'] > 0)
                                              ? ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3))),
                                                  onPressed: () {
                                                    // Decreasing cart qty by using minus icon
                                                    DialogsWidget
                                                        .showProgressBar(
                                                            context,
                                                            _controller);
                                                    Apis.removetocart(
                                                            addtocartdoc,
                                                            documentSnapshot)
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        documentSnapshot['qty'];
                                                      });
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 17,
                                                  ))
                                              : ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3))),
                                                  onPressed: () {
                                                    // Delete from Cart
                                                    DialogsWidget
                                                        .showProgressBar(
                                                            context,
                                                            _controller);
                                                    Apis.deletefromcart(
                                                            addtocartdoc,
                                                            documentSnapshot)
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        documentSnapshot['qty'];
                                                      });
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.delete,
                                                    size: 17,
                                                  ))),
                                      SizedBox(
                                          width: mq.width * .1,
                                          height: mq.height * .035,
                                          child: Center(
                                              child: Text(
                                            documentSnapshot['qty'].toString(),
                                          ))),
                                      SizedBox(
                                          width: mq.width * .1,
                                          height: mq.height * .03,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.all(0),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3))),
                                              onPressed: () {
                                                // Icreasing cart qty by using plus icon
                                                DialogsWidget.showProgressBar(
                                                    context, _controller);
                                                Apis.addtocart(addtocartdoc,
                                                        documentSnapshot)
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    documentSnapshot['qty'];
                                                  });
                                                });
                                              },
                                              child: const Icon(
                                                Icons.add,
                                                size: 17,
                                              ))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }
            }),
      ),
    );
  }
}
