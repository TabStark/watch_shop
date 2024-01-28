import 'package:flutter/material.dart';
import 'package:watch_shop/Colors/app_colors.dart';
import 'package:watch_shop/apis/apis.dart';
import 'package:watch_shop/main.dart';
import 'package:watch_shop/popup%20and%20loader/dialogs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  bool namebool = true;
  bool phonebool = true;
  bool addressbool = true;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  // Loading Animation
  late final AnimationController _Animationcontroller =
      AnimationController(duration: Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void initState() {
    super.initState();
    _nameController.text = (Apis.me.name == 'null') ? 'User' : Apis.me.name;
    _phoneNoController.text = (Apis.me.phone == 'null') ? '' : Apis.me.phone;
    _addressController.text = Apis.me.address;
  }

  @override
  void dispose() {
    super.dispose();
    _Animationcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().white,
        leading: BackButton(color: AppColor().black),
        title: Text(
          "Profile",
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
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColor().NewgoldBrown,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(mq.width * 0.08),
                          bottomRight: Radius.circular(mq.width * 0.08))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mq.width * 0.08, vertical: mq.height * .05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: mq.width * 0.12,
                          backgroundImage: NetworkImage(Apis.me.img),
                        ),
                        SizedBox(
                          width: mq.width * 0.03,
                        ),
                        const Text(
                          'Hii, ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        //  Name
                        Expanded(
                            child: TextFormField(
                          controller: _nameController,
                          onSaved: (val) {
                            Apis.me.name = val ?? "";
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required Field';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                          readOnly: namebool,
                          // initialValue: Apis.me.name,
                          autofocus: true,
                          decoration: InputDecoration(
                              hintText: 'Enter Name',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      namebool = !namebool;
                                    });
                                  },
                                  icon: const Icon(Icons.edit))),
                        ))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mq.height * .05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.width * 0.1),
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                        readOnly: true,
                        initialValue: Apis.me.email,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Your Email',
                          hintText: 'Enter Email',
                          labelStyle: TextStyle(fontSize: 20),
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(height: mq.height * .05),

                      // Phone No
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _phoneNoController,
                        onSaved: (val) => Apis.me.phone = val ?? "",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required Field';
                          } else {
                            return null;
                          }
                        },
                        maxLength: 10,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                        readOnly: phonebool,
                        // initialValue: Apis.me.name,
                        autofocus: true,
                        decoration: InputDecoration(
                            hintText: 'Enter Mobile No',
                            labelText: 'Your Mobile No',
                            labelStyle: TextStyle(fontSize: 20),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    phonebool = !phonebool;
                                  });
                                },
                                icon: const Icon(Icons.edit))),
                      ),
                      SizedBox(height: mq.height * .05),

                      // Address
                      TextFormField(
                        controller: _addressController,
                        onSaved: (val) => Apis.me.address = val ?? "",
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required Field';
                          } else {
                            return null;
                          }
                        },
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                        readOnly: addressbool,
                        // initialValue: Apis.me.address,
                        autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Your Address',
                            hintText: 'Enter  Address',
                            labelStyle: TextStyle(fontSize: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: AppColor().grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: AppColor().NewgoldBrown)),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    addressbool = !addressbool;
                                  });
                                },
                                icon: const Icon(Icons.edit))),
                      ),
                      SizedBox(height: mq.height * .05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: mq.height * .055,
                            width: mq.width * 0.37,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    backgroundColor: AppColor().white),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color: Color(0xff0a0200),
                                        fontSize: 18))),
                          ),
                          SizedBox(
                            height: mq.height * .055,
                            width: mq.width * 0.37,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    backgroundColor: AppColor().NewgoldBrown),
                                onPressed: () async {
                                  if (_form.currentState!.validate()) {
                                    _form.currentState!.save();
                                    DialogsWidget.showProgressBar(
                                        context, _Animationcontroller);
                                    await Apis.updateuserinfo().then((value) {
                                      Navigator.pop(context);
                                      DialogsWidget.showFlushBar(context,
                                          'Detail Updated Successfullt');
                                    });
                                  }
                                },
                                child: Text('Save',
                                    style: TextStyle(
                                        color: Color(0xff0a0200),
                                        fontSize: 18))),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
