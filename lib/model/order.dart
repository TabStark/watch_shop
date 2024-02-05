class OrderJson {
  OrderJson({
    required this.img,
    required this.price,
    required this.discription,
    required this.name,
    required this.arrayimg,
    required this.brand,
    required this.qty,
    required this.ordertime,
  });
  late final String img;
  late final String price;
  late final String name;
  late final String discription;
  late final List<dynamic> arrayimg;
  late final String brand;
  late final int qty;
  late final String ordertime;

  OrderJson.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    price = json['price'];
    name = json['name'];
    arrayimg = List.castFrom(json['arrayimg'] ?? []);
    brand = json['brand'];
    discription = json['discription'];
    qty = json['qty'];
    ordertime = json['ordertime'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['img'] = img;
    _data['price'] = price;
    _data['name'] = name;
    _data['arrayimg'] = arrayimg;
    _data['brand'] = brand;
    _data['discription'] = discription;
    _data['qty'] = qty;
    _data['ordertime'] = ordertime;
    return _data;
  }
}
