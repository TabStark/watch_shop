import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';
import 'package:watch_shop/screens/addtocart.dart';
import 'package:watch_shop/screens/order_items.dart';
import 'package:watch_shop/screens/profile_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget>
    with TickerProviderStateMixin {
  late final AnimationController controller =
      AnimationController(duration: Duration(seconds: 3), vsync: this)
        ..repeat();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: [
        DrawerHeader(
            decoration: BoxDecoration(color: AppColor().NewgoldBrown),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: mq.width * .1,
                  backgroundImage: NetworkImage(Apis.me.img),
                ),
                Text(Apis.me.email)
              ],
            )),
        ListTile(
          title: Row(
            children: [
              Icon(
                Icons.home_outlined,
                size: 30,
                color: AppColor().NewgoldBrown,
              ),
              SizedBox(
                width: mq.width * .02,
              ),
              Text(
                'Home',
                style: TextStyle(color: AppColor().black, fontSize: 18),
              )
            ],
          ),
          onTap: () => Navigator.pop(context),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10), child: Divider()),
        // Profile
        ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 30,
                  color: AppColor().NewgoldBrown,
                ),
                SizedBox(
                  width: mq.width * .02,
                ),
                Text(
                  'Profile',
                  style: TextStyle(color: AppColor().black, fontSize: 18),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            }),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10), child: Divider()),
        // Add to Carts
        ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 30,
                  color: AppColor().NewgoldBrown,
                ),
                SizedBox(
                  width: mq.width * .02,
                ),
                Text(
                  'Carts',
                  style: TextStyle(color: AppColor().black, fontSize: 18),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddToCart()));
            }),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10), child: Divider()),
        ListTile(
          title: Row(
            children: [
              Icon(
                Icons.favorite_outline,
                size: 30,
                color: AppColor().NewgoldBrown,
              ),
              SizedBox(
                width: mq.width * .02,
              ),
              Text(
                'Favorite',
                style: TextStyle(color: AppColor().black, fontSize: 18),
              )
            ],
          ),
          onTap: () => Navigator.pop(context),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10), child: Divider()),
        ListTile(
          title: Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 30,
                color: AppColor().NewgoldBrown,
              ),
              SizedBox(
                width: mq.width * .02,
              ),
              Text(
                'My Order',
                style: TextStyle(color: AppColor().black, fontSize: 18),
              )
            ],
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OrderItems()));
          },
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10), child: Divider()),
        ListTile(
          title: Row(
            children: [
              Icon(
                Icons.settings_outlined,
                size: 30,
                color: AppColor().NewgoldBrown,
              ),
              SizedBox(
                width: mq.width * .02,
              ),
              Text(
                'Settings',
                style: TextStyle(color: AppColor().black, fontSize: 18),
              )
            ],
          ),
          onTap: () => Navigator.pop(context),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10), child: Divider()),
        ListTile(
          title: Row(
            children: [
              Icon(
                Icons.logout,
                size: 30,
                color: AppColor().NewgoldBrown,
              ),
              SizedBox(
                width: mq.width * .02,
              ),
              Text(
                'Logout',
                style: TextStyle(color: AppColor().black, fontSize: 18),
              )
            ],
          ),
          onTap: () => Apis().logoutFromDevice(context, controller),
        ),
      ]),
    );
  }
}
