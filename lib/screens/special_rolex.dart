import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';

class SpecialRolex extends StatefulWidget {
  final String collection;
  final String docs;
  final String subsollection;
  const SpecialRolex(
      {super.key,
      required this.collection,
      required this.docs,
      required this.subsollection});

  @override
  State<SpecialRolex> createState() => _SpecialRolexState();
}

class _SpecialRolexState extends State<SpecialRolex> {
  // for search
  bool search = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: AppColor().oriGrey,
        ),
        backgroundColor: AppColor().black54,
        title: search
            ? TextFormField(
                style: TextStyle(color: AppColor().white, fontSize: 19),
                autofocus: true,
                decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: AppColor().oriGrey),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    filled: true,
                    fillColor: AppColor().grey,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            search = !search;
                          });
                        },
                        icon: Icon(
                          Icons.highlight_remove_outlined,
                          size: 28,
                          color: AppColor().oriGrey,
                        ))),
              )
            : Text(
                widget.subsollection,
                style: TextStyle(color: AppColor().oriGrey),
              ),
        actions: [
          if (!search)
            IconButton(
                onPressed: () {
                  setState(() {
                    search = !search;
                  });
                },
                icon: Icon(
                  Icons.search,
                  size: 28,
                  color: AppColor().oriGrey,
                )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none,
                size: 30,
                color: AppColor().oriGrey,
              ))
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColor().black,
        child: StreamBuilder(
            stream: Apis.fetchstream(
                    widget.collection, widget.docs, widget.subsollection)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
              if (snapShot.hasData) {
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: GridView.builder(
                      itemCount: snapShot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: .6),
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            snapShot.data!.docs[index];
                        print(snapShot.data!.docs.length);
                        return Padding(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          color: AppColor().white),
                                    ),
                                    Text(documentSnapshot['price'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColor().white))
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
