import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:watch_shop/popup%20and%20loader/dialogs.dart';
import 'package:watch_shop/screens/buy_now.dart';

class ViewProductDetail extends StatefulWidget {
  final String docId;
  final DocumentSnapshot documentSnapshot;
  const ViewProductDetail(
      {super.key, required this.documentSnapshot, required this.docId});

  @override
  State<ViewProductDetail> createState() => _ViewProductDetailState();
}

class _ViewProductDetailState extends State<ViewProductDetail> {
  List<String> extractimg() {
    List<String> arrayImage = [];
    for (var i in widget.documentSnapshot['arrayimg']) {
      arrayImage.add(i);
    }
    return arrayImage;
  }

  // Check if its firebolt or not
  bool checkfireboltt() {
    if (widget.documentSnapshot['brand'] == 'fire') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String rolex = widget.documentSnapshot['brand'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            (rolex == 'Rolex') ? AppColor().black54 : AppColor().white,
        leading: BackButton(
            color: (rolex == 'Rolex') ? AppColor().oriGrey : AppColor().black),
        title: Text(
          widget.documentSnapshot['brand'],
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
        height: double.infinity,
        width: double.infinity,
        color: (rolex == 'Rolex') ? AppColor().black : AppColor().white,
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: mq.width * .07),
                      width: double.infinity,
                      height: mq.height * .55,
                      color: (rolex == 'Rolex')
                          ? AppColor().black
                          : AppColor().white,
                      child: FanCarouselImageSlider(
                        imagesLink: extractimg(),
                        isAssets: false,
                        sliderHeight: mq.height * .5,
                        sliderWidth: mq.width * 1,
                        imageRadius: 10,
                        sidesOpacity: 0.0,
                        imageFitMode: BoxFit.contain,
                        slideViewportFraction: 1,
                        indicatorActiveColor: AppColor().NewgoldBrown,
                        expandedImageFitMode: BoxFit.contain,
                        autoPlay: false,
                        initalPageIndex: 0,
                        currentItemShadow: [
                          BoxShadow(
                              blurRadius: 0,
                              color: (rolex == 'Rolex')
                                  ? AppColor().black
                                  : AppColor().white)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: mq.width * .03, vertical: mq.width * .05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.documentSnapshot['brand'],
                            style: TextStyle(
                                color: AppColor().lightgrey, fontSize: 17),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.documentSnapshot['name'],
                            style: TextStyle(
                                fontSize: 17,
                                color: (rolex == 'Rolex')
                                    ? AppColor().white
                                    : AppColor().black),
                          ),
                          if (widget.documentSnapshot['brand'] == 'Fire-Boltt')
                            const SizedBox(
                              height: 5,
                            ),
                          if (widget.documentSnapshot['brand'] == 'Fire-Boltt')
                            Text(
                              "${widget.documentSnapshot['discription']}",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: (rolex == 'Rolex')
                                      ? AppColor().white
                                      : AppColor().black),
                            ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "${widget.documentSnapshot['price']}.00",
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                                color: (rolex == 'Rolex')
                                    ? AppColor().white
                                    : AppColor().black),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '*Inclusive of all taxes',
                            style: TextStyle(
                                color: AppColor().lightgrey, fontSize: 17),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: mq.height * .09),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.security,
                                        size: 25,
                                        color: (rolex == 'Rolex')
                                            ? AppColor().white
                                            : AppColor().black),
                                    Text(
                                      '100% secure and safe transaction',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: (rolex == 'Rolex')
                                              ? AppColor().white
                                              : AppColor().black),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.verified_user_outlined,
                                        size: 25,
                                        color: (rolex == 'Rolex')
                                            ? AppColor().white
                                            : AppColor().black),
                                    Text(
                                      '100% genuine products',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: (rolex == 'Rolex')
                                              ? AppColor().white
                                              : AppColor().black),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.handshake_outlined,
                                        size: 25,
                                        color: (rolex == 'Rolex')
                                            ? AppColor().white
                                            : AppColor().black),
                                    Text(
                                      'Authorised dealers',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: (rolex == 'Rolex')
                                              ? AppColor().white
                                              : AppColor().black),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.lightbulb_outline,
                                        size: 25,
                                        color: (rolex == 'Rolex')
                                            ? AppColor().white
                                            : AppColor().black),
                                    Text(
                                      'Leaders in watch retail since 1948',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: (rolex == 'Rolex')
                                              ? AppColor().white
                                              : AppColor().black),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
            Positioned(
                bottom: 0.0,
                child: Container(
                  height: mq.height * .088,
                  width: mq.width * 1,
                  color:
                      (rolex == 'Rolex') ? AppColor().black : AppColor().white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: mq.height * .06,
                        width: mq.width * 0.38,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: (rolex == 'Rolex')
                                    ? AppColor().oriGrey
                                    : AppColor().white,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    side: BorderSide(color: AppColor().black)),
                                backgroundColor: AppColor().white),
                            onPressed: () {
                              Apis.addtocart(
                                      widget.docId, widget.documentSnapshot)
                                  .then((value) {
                                DialogsWidget.showFlushBarBottom(
                                    context, 'Successfully Added to Cart');
                              });
                            },
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                  color: AppColor().black, fontSize: 18),
                            )),
                      ),
                      SizedBox(
                        height: mq.height * .06,
                        width: mq.width * 0.4,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: (rolex == 'Rolex')
                                    ? AppColor().oriGrey
                                    : AppColor().white,
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor: AppColor().NewgoldBrown),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BuyNow(
                                          docId: widget.docId,
                                          documentSnapshot:
                                              widget.documentSnapshot)));
                            },
                            child: Text('Buy Now',
                                style: TextStyle(
                                    color: Color(0xff0a0200), fontSize: 18))),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
