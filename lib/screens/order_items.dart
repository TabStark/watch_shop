import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';
import 'package:watch_shop/screens/home_screen.dart';
import 'package:watch_shop/screens/order_history.dart';

class OrderItems extends StatefulWidget {
  const OrderItems({
    super.key,
  });

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().white,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor().black,
            )),
        title: Text(
          "My Order",
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
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColor().white,
          child: StreamBuilder(
              stream: Apis.fetchstream('users', Apis.user.uid, 'myOrder')
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
                            padding: const EdgeInsets.symmetric(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                          // final data = snapShot.data!.docs;
                          // To take a json
                          // print("Data : ${jsonEncode(data[0].data())}");
                          final DocumentSnapshot documentSnapshot =
                              snapShot.data!.docs[index];

                          final String docid =
                              snapShot.data!.docs[index].reference.id;

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderHistory(
                                            documentSnapshot: documentSnapshot,
                                            docId: docid,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: mq.width * 0.3,
                                          child: Image.network(
                                              documentSnapshot['img'])),
                                      SizedBox(
                                        width: mq.width * 0.01,
                                      ),
                                      SizedBox(
                                        width: mq.width * .6,
                                        height: mq.height * 0.16,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
              }),
        ),
      ),
    );
  }
}
