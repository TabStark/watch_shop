import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/custom%20widgets/custom_cards_for_home.dart';
import 'package:watch_shop/custom%20widgets/drawer.dart';
import 'package:watch_shop/main.dart';
import 'package:watch_shop/screens/showList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference collections = FirebaseFirestore.instance
      .collection('watchcollections')
      .doc('11')
      .collection('TAG Heuer');

  // Search COntroller
  TextEditingController _searchController = TextEditingController();

  // To check search contains subcollection name
  List<String> _searchList = [];

  // To check search contains doc id
  List<String> _searchdocList = [];
  // for search
  bool search = false;

  // Brand List
  List<String> brand = [];

  // DocList
  List<String> _docList = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '1',
    '10',
    '11'
  ];
  // For Brands Name
  Future<void> brands() async {
    final List<String> brand_list = [];
    var collections = Apis.firestore.collection('watchcollections');
    var querySnapshot = await collections.get();
    for (var i in querySnapshot.docs) {
      Map<String, dynamic> data = i.data();
      brand_list.add(data['name']);
    }
    setState(() {
      brand = brand_list;
    });
  }

  // Scroll The Brands Name
  ScrollController _scrollController = ScrollController();

  int _currentINdex = -1;

  // late Timer _timer;

  void _scrolltoNextItem() {
    if (_currentINdex <= brand.length + 1) {
      _currentINdex++;
    } else {
      _currentINdex = -1;
    }

    _scrollController.animateTo(_currentINdex * 150.0,
        duration: Duration(milliseconds: 1200), curve: Curves.easeIn);
  }

  @override
  void initState() {
    Apis.getUserData().then((value) {
      brands();
      // _timer = Timer.periodic(Duration(milliseconds: 1200), (timer) {
      //   _scrolltoNextItem();
      // });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Reusable Container for Watches
    Widget reusableContainer(String img, String name) {
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
                img,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  size: 28,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: search
              ? TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    _searchList.clear();
                    _searchdocList.clear();
                    // brand.forEach((element) {
                    //   print("FOr each${element}");
                    // });
                    for (var element in brand.asMap().entries) {
                      var index = element.key;
                      var i = element.value;
                      if (i.toLowerCase().contains(value.toLowerCase())) {
                        _searchList.add(i);
                        _searchdocList.add(_docList[index]);
                        print(" value ${_docList[index]}");
                        // print("Index value ${_docList[index]}");
                        // print("DocList value ${_searchdocList}");
                      }
                      setState(() {
                        _searchList;
                        _searchdocList;
                      });
                    }
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: "Search",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      filled: true,
                      fillColor: AppColor().oriGrey,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              search = !search;
                              print(search);
                            });
                          },
                          icon: const Icon(
                            Icons.highlight_remove_outlined,
                            size: 28,
                          ))),
                )
              : const Text("LuxInfinity"),
          actions: [
            if (!search)
              IconButton(
                  onPressed: () {
                    setState(() {
                      _searchList.clear();
                      _searchController.text = '';
                      search = !search;
                      print(search);
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 28,
                  )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none,
                  size: 30,
                ))
          ],
        ),
        body: search
            ? GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: WillPopScope(
                  onWillPop: () {
                    if (search) {
                      setState(() {
                        search = !search;
                      });
                      return Future.value(false);
                    } else {
                      return Future.value(true);
                    }
                  },
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: AppColor().white,
                      child: ListView.builder(
                          itemCount: search ? _searchList.length : brand.length,
                          itemBuilder: (context, index) {
                            print(brand);
                            if (brand.isNotEmpty) {
                              return InkWell(
                                onTap: () {
                                  print('Doc id ${_searchdocList[index]}');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShowList(
                                              collection: 'watchcollections',
                                              docs: search
                                                  ? _searchdocList[index]
                                                  : _docList[index],
                                              subsollection: search
                                                  ? _searchList[index]
                                                  : brand[index])));
                                },
                                child: Container(
                                  height: mq.height * 0.07,
                                  padding: EdgeInsets.symmetric(
                                      vertical: mq.height * 0.02,
                                      horizontal: mq.width * 0.05),
                                  child: Text(
                                    search ? _searchList[index] : brand[index],
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: Text('No Result Found'),
                              );
                            }
                          })),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://www.essential-watches.com/images/RolexCollection_v2.jpg'),
                              fit: BoxFit.cover)),
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rolex Collection',
                            style: TextStyle(
                                color: AppColor().white, fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text("Shop Our Rolex Collection",
                              style: TextStyle(
                                  color: AppColor().white,
                                  fontFamily: 'LibreBaskerville',
                                  fontSize: 19)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                              'Authentic and incomparable \ntimepieces from the King of watches',
                              style: TextStyle(
                                  color: AppColor().white, fontSize: 16)),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: mq.width * 0.3,
                            height: mq.height * 0.04,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  backgroundColor: AppColor().darkgreen),
                              onPressed: () {
                                // Apis.brands();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const ShowList(
                                            collection: 'watchcollections',
                                            docs: '08',
                                            subsollection: 'Rolex')));
                              },
                              child: Text(
                                "Explore",
                                style: TextStyle(color: AppColor().white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    // Brands Name Carusole
                    SizedBox(
                      height: mq.height * .1,
                      child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: brand.length,
                          itemBuilder: (context, index) {
                            print(brand.length);
                            return Padding(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                width: mq.width * 0.4,
                                height: mq.height * .06,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(
                                        color: AppColor().darkgoldBrown,
                                        width: 2)),
                                child: Center(
                                    child: Text(
                                  brand[index].toUpperCase(),
                                  style: TextStyle(
                                      color: AppColor().darkgoldBrown,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: mq.height * 0.05,
                    ),

                    // Luxury Swiss Watch
                    const SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        'Luxury Swiss Brands',
                        style: TextStyle(
                            fontSize: 22, decoration: TextDecoration.underline),
                      )),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        height: 420,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '04',
                                                      subsollection:
                                                          'Blancpain')));
                                    },
                                    child: const CustomCardsOne(
                                        name: 'Blancpain',
                                        img:
                                            'https://zimsonwatches.com/cdn/shop/products/6654-3640-55.jpg?v=1686547417&width=535')),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '10',
                                                      subsollection:
                                                          'Breitling')));
                                    },
                                    child: const CustomCardsOne(
                                        name: 'Breitling',
                                        img:
                                            'https://zimsonwatches.com/cdn/shop/products/ab2510201k1p1.jpg?v=1686636255&width=535')),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '11',
                                                      subsollection:
                                                          'TAG Heuer')));
                                    },
                                    child: const CustomCardsOne(
                                        name: 'TAG Heuer',
                                        img:
                                            'https://tagheuerindia.com/image/cache/catalog/WBN2311.BA0001_1-500x837.png')),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '03',
                                                      subsollection:
                                                          'Tissot')));
                                    },
                                    child: const CustomCardsOne(
                                        name: 'Tissot',
                                        img:
                                            'https://cdn.shopify.com/s/files/1/0261/8900/4880/products/t1224173603300.jpg?v=1686311432&width=535')),
                              ],
                            )
                          ],
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShowList(
                                    collection: 'watchcollections',
                                    docs: '10',
                                    subsollection: 'Breitling')));
                      },
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        decoration: BoxDecoration(color: AppColor().dkgreen),
                        padding: EdgeInsets.only(left: 20),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              right: 0,
                              child: SizedBox(
                                  width: mq.width * 0.6,
                                  height: mq.width * 0.6,
                                  child: Image.network(
                                    'https://scontent.cdninstagram.com/v/t39.30808-6/419630001_352700024174849_3974975078541041493_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=18de74&_nc_ohc=MQGO_0ExoFwAX8sTmX_&_nc_ht=scontent.cdninstagram.com&edm=ANo9K5cEAAAA&oh=00_AfA_s4nHN0Nh5LADfFPNxVDw7Cecp51jakCz9r1Icng8sA&oe=65BB01D1',
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            Positioned(
                              left: 0,
                              child: Text(
                                'World-class watch \nmade for you',
                                style: TextStyle(
                                    color: AppColor().white,
                                    fontFamily: 'LibreBaskerville',
                                    fontSize: 19),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * 0.05,
                    ),

                    // Explore The Collection
                    const SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        'Explore The Collection',
                        style: TextStyle(
                            fontSize: 22, decoration: TextDecoration.underline),
                      )),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        height: 630,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '1',
                                                      subsollection:
                                                          'Fossil')));
                                    },
                                    child: const CustomCardsOne(
                                        name: 'Fossil',
                                        img:
                                            'https://cdn.shopify.com/s/files/1/0261/8900/4880/files/ME3171.jpg?v=1704969993')),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '1',
                                                      subsollection:
                                                          'Fossil')));
                                    },
                                    child: const CustomCardsOne(
                                        name: 'Fossil',
                                        img:
                                            'https://cdn.shopify.com/s/files/1/0261/8900/4880/files/FS4552.jpg?v=1704721663')),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '05',
                                                      subsollection:
                                                          'Balmain')));
                                    },
                                    child: const CustomCardsOne(
                                        name: 'Balmain',
                                        img:
                                            'https://zimsonwatches.com/cdn/shop/files/B74813372.jpg?v=1705054543')),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '05',
                                                      subsollection:
                                                          'Balmain')));
                                    },
                                    child: const CustomCardsOne(
                                      name: 'Balmain',
                                      img:
                                          'https://zimsonwatches.com/cdn/shop/files/B53613262.jpg?v=1705051706',
                                    )),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '07',
                                                      subsollection:
                                                          'Tommy Hilfiger')));
                                    },
                                    child: const CustomCardsOne(
                                        name: 'Tommy Hilfiger',
                                        img:
                                            'https://zimsonwatches.com/cdn/shop/products/TH1791635_0e31e4ac-c1a5-4b01-a06b-8aa389ee7433.jpg?v=1687169417&width=535')),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '07',
                                                      subsollection:
                                                          'Tommy Hilfiger')));
                                    },
                                    child: const CustomCardsOne(
                                        name: 'Tommy Hilfiger',
                                        img:
                                            'https://cdn.shopify.com/s/files/1/0261/8900/4880/products/NCTH1791707.jpg?v=1687162569&width=535')),
                              ],
                            )
                          ],
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShowList(
                                    collection: 'watchcollections',
                                    docs: '06',
                                    subsollection: 'Fire Bolt')));
                      },
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        child: Image.network(
                          'https://i.gadgets360cdn.com/large/Fire-Boltt_Quantum_main_1676383979737.jpg?downsize=950:*',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mq.height * 0.05,
                    ),

                    // Shop Online
                    const SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        'Shop Online Now',
                        style: TextStyle(
                            fontSize: 22, decoration: TextDecoration.underline),
                      )),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        height: 800,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '03',
                                                      subsollection:
                                                          'Tissot')));
                                    },
                                    child: const CustomCardsTwo(
                                        name: 'Tissot',
                                        img:
                                            'https://zimsonwatches.com/cdn/shop/files/tissot_b0d6385e-e035-4c98-8798-ee7a482ac07e.png?v=1682609938&width=535')),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '01',
                                                      subsollection:
                                                          'Michael Kors')));
                                    },
                                    child: const CustomCardsTwo(
                                        name: 'Michael Kors',
                                        img:
                                            'https://zimsonwatches.com/cdn/shop/files/MICHAEL_KORS.png?v=1682609937&width=535')),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '09',
                                                      subsollection: 'Titan')));
                                    },
                                    child: const CustomCardsTwo(
                                        name: 'Titan',
                                        img:
                                            'https://zimsonwatches.com/cdn/shop/files/TITEN.png?v=1682609935&width=535')),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '1',
                                                      subsollection:
                                                          'Fossil')));
                                    },
                                    child: const CustomCardsTwo(
                                        name: 'Fossil',
                                        img:
                                            'https://zimsonwatches.com/cdn/shop/files/fossil_f893499c-bd2d-40cf-8dc0-cfec028b4a5d.png?v=1682609938&width=535')),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '05',
                                                      subsollection:
                                                          'Balmain')));
                                    },
                                    child: const CustomCardsTwo(
                                        name: 'Balmain',
                                        img:
                                            'https://zimsonwatches.com/cdn/shop/files/balman.png?v=1682609939&width=535')),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ShowList(
                                                      collection:
                                                          'watchcollections',
                                                      docs: '02',
                                                      subsollection: 'Seiko')));
                                    },
                                    child: const CustomCardsTwo(
                                        name: 'Seiko',
                                        img:
                                            'https://zimsonwatches.com/cdn/shop/files/seiko_963fd0a0-1356-445a-9eb4-8a52775e9790.png?v=1682610510&width=535')),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
        drawer: const DrawerWidget());
  }
}
