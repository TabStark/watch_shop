import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';
import 'package:watch_shop/screens/view_product.dart';

class ShowList extends StatefulWidget {
  final String collection;
  final String docs;
  final String subsollection;
  const ShowList(
      {super.key,
      required this.collection,
      required this.docs,
      required this.subsollection});

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {

  @override
  Widget build(BuildContext context) {
    String rolex = widget.subsollection;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            (rolex == 'Rolex') ? AppColor().black54 : AppColor().white,
        leading: BackButton(
            color: (rolex == 'Rolex') ? AppColor().oriGrey : AppColor().black),
        title: Text(
          widget.subsollection,
          style: TextStyle(
              color:
                  (rolex == 'Rolex') ? AppColor().oriGrey : AppColor().black),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                size: 30,
                color:
                    (rolex == 'Rolex') ? AppColor().oriGrey : AppColor().black,
              ))
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: (rolex == 'Rolex') ? AppColor().black : AppColor().white,
        child: StreamBuilder(
            stream: Apis.fetchstream(
                    widget.collection, widget.docs, widget.subsollection)
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
                        baseColor: (rolex == 'Rolex')
                            ? Colors.grey.shade900
                            : Colors.grey.shade300,
                        highlightColor: (rolex == 'Rolex')
                            ? Colors.grey.shade700
                            : Colors.grey.shade100,
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
                  child: GridView.builder(
                      itemCount: snapShot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: .6),
                      itemBuilder: (context, index) {
                        // final data = snapShot.data!.docs;
                        // To take a json
                        // print("Data : ${jsonEncode(data[0].data())}");
                        final DocumentSnapshot documentSnapshot =
                            snapShot.data!.docs[index];

                        return InkWell(
                          onTap: () {
                            final String docid =
                                snapShot.data!.docs[index].reference.id;
                            final String addtocartdoc =
                                widget.subsollection + docid;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewProductDetail(
                                          documentSnapshot: documentSnapshot,
                                          docId: addtocartdoc,
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: mq.height * 0.22,
                                    child:
                                        Image.network(documentSnapshot['img'])),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
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
                                            color: (rolex == 'Rolex')
                                                ? AppColor().white
                                                : AppColor().black),
                                      ),
                                      Text(documentSnapshot['price'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: (rolex == 'Rolex')
                                                  ? AppColor().white
                                                  : AppColor().black))
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
