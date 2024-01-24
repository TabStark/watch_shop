import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarsouleWidget extends StatefulWidget {
  const CarsouleWidget({super.key});

  @override
  State<CarsouleWidget> createState() => _CarsouleWidgetState();
}

class _CarsouleWidgetState extends State<CarsouleWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CarouselSlider(
            items: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://i.pinimg.com/474x/aa/31/d7/aa31d7d623f00d1aa55b10c51f43ab70.jpg'),
                        fit: BoxFit.contain)),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://i.pinimg.com/474x/fc/cf/b1/fccfb12b5e69e34b9f497046e23dfcf3.jpg'),
                        fit: BoxFit.contain)),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://i.pinimg.com/474x/11/19/87/1119873f1500f6a785a59d75c9d08ca0.jpg'),
                        fit: BoxFit.contain)),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://i.pinimg.com/474x/ca/f7/4f/caf74f77109aac7296233363d523b859.jpg'),
                        fit: BoxFit.contain)),
              )
            ],
            options: CarouselOptions(
              height: 300,
              aspectRatio: 16 / 16,
              viewportFraction: 0.5,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ))
      ],
    );
  }
}
