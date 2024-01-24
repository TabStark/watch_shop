import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/main.dart';

class CustomCardsOne extends StatefulWidget {
  final String name;
  final String img;
  const CustomCardsOne({super.key, required this.name, required this.img});

  @override
  State<CustomCardsOne> createState() => _CustomCardsOneState();
}

class _CustomCardsOneState extends State<CustomCardsOne> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: mq.width * 0.45,
      height: mq.width * 0.46,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor().oriGrey)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: mq.width * 0.37,
            child: Image.network(
              widget.img,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            widget.name,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}

// Custom card Two
class CustomCardsTwo extends StatefulWidget {
  final String img;
  final String name;
  const CustomCardsTwo({super.key, required this.img, required this.name});

  @override
  State<CustomCardsTwo> createState() => _CustomCardsTwoState();
}

class _CustomCardsTwoState extends State<CustomCardsTwo> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: mq.width * 0.45,
        height: mq.width * 0.6,
        padding:
            EdgeInsets.only(left: mq.width * 0.03, bottom: mq.width * 0.01),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.img), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor().oriGrey)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                  fontSize: 20,
                  color: AppColor().white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
