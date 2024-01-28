class LoggedUser {
  LoggedUser({
    required this.img,
    required this.address,
    required this.phone,
    required this.name,
    required this.id,
    required this.email,
  });
  late String img;
  late String address;
  late String phone;
  late String name;
  late String id;
  late String email;

  LoggedUser.fromJson(Map<String, dynamic> json) {
    img = json['img'] ?? '';
    address = json['address'] ?? '';
    phone = json['phone'] ?? '';
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['img'] = img;
    _data['address'] = address;
    _data['phone'] = phone;
    _data['name'] = name;
    _data['id'] = id;
    _data['email'] = email;
    return _data;
  }
}
