import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:watch_shop/model/addtocartjson.dart';
import 'package:watch_shop/model/logged_user.dart';
import 'package:watch_shop/model/order.dart';
import 'package:watch_shop/popup%20and%20loader/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_shop/screens/home_screen.dart';
import 'package:watch_shop/screens/login_screen.dart';

class Apis {
  // Firease Auth
  static FirebaseAuth auth = FirebaseAuth.instance;

  // Firebase Cloud
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Current user auth
  static User get user => auth.currentUser!;

  // Check the user is exist or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // Storing user data
  static LoggedUser me = LoggedUser(
    img: user.photoURL?.toString() ??
        'https://png.pngitem.com/pimgs/s/274-2748514_profile-icon-material-design-hd-png-download.png',
    address: '',
    phone: user.phoneNumber.toString(),
    name: user.displayName.toString(),
    id: user.uid.toString(),
    email: user.email.toString(),
  );

  // Create new user in cloud firestore
  static Future<void> createUser() async {
    final loggedUser = LoggedUser(
        img: user.photoURL?.toString() ??
            'https://png.pngitem.com/pimgs/s/274-2748514_profile-icon-material-design-hd-png-download.png',
        address: "",
        phone: user.phoneNumber.toString(),
        name: user.displayName.toString(),
        email: user.email.toString(),
        id: user.uid);

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(loggedUser.toJson());
  }

  // Getting user data
  static Future getUserData() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = LoggedUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getUserData);
      }
    });
  }

  // Update User Info
  static Future<void> updateuserinfo() async {
    print(me.phone);
    firestore.collection('users').doc(user.uid).update({
      'name': me.name.trim(),
      'phone': me.phone.trim(),
      'address': me.address.trim()
    });
  }

  // Default stream Builder
  static CollectionReference<Object?> fetchstream(
      String Collction, String docs, String subCollection) {
    final CollectionReference collections =
        firestore.collection(Collction).doc(docs).collection(subCollection);

    return collections;
  }

  // Default stream Builder
  static CollectionReference<Object?> fetchstreamsearch(String Collction) {
    final CollectionReference collections = firestore.collection(Collction);

    return collections;
  }

  // AddtoCart
  static Future<void> addtocart(
      String brandId, DocumentSnapshot documentSnapshot) async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('myaddtocart')
        .doc(brandId)
        .get()
        .then((value) async {
      if (value.exists) {
        await firestore
            .collection('users')
            .doc(user.uid)
            .collection('myaddtocart')
            .doc(brandId)
            .update({"qty": value['qty'] + 1});
      } else {
        final Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        final AddtoCartJson dids = AddtoCartJson(
          img: documentSnapshot['img'],
          price: documentSnapshot['price'],
          name: documentSnapshot['name'],
          arrayimg: documentSnapshot['arrayimg'],
          brand: documentSnapshot['brand'],
          discription:
              data.containsKey('discription') ? data['discription'] : '',
          qty: 1,
        );

        firestore
            .collection('users')
            .doc(user.uid)
            .collection('myaddtocart')
            .doc(brandId)
            .set(dids.toJson());
        print('Data: ${brandId} \nData:${documentSnapshot['arrayimg']}');
      }
    });
  }

  // remove from cart
  static Future<void> removetocart(String brandId) async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('myaddtocart')
        .doc(brandId)
        .get()
        .then((value) async {
      if (value.exists) {
        print(value['qty']);
        await firestore
            .collection('users')
            .doc(user.uid)
            .collection('myaddtocart')
            .doc(brandId)
            .update({"qty": value['qty'] - 1});
      }
    });
  }

  // Delete from Cart
  static Future<void> deletefromcart(String brandId) async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('myaddtocart')
        .doc(brandId)
        .get()
        .then((value) async {
      if (value.exists) {
        print(value['qty']);
        await firestore
            .collection('users')
            .doc(user.uid)
            .collection('myaddtocart')
            .doc(brandId)
            .delete();
      }
    });
  }

  // Order
  static Future<void> OrderItem(
      String brandId, DocumentSnapshot documentSnapshot) async {
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final OrderJson myOrder = OrderJson(
      img: documentSnapshot['img'],
      price: documentSnapshot['price'],
      name: documentSnapshot['name'],
      arrayimg: documentSnapshot['arrayimg'],
      brand: documentSnapshot['brand'],
      discription: data.containsKey('discription') ? data['discription'] : '',
      qty: data.containsKey('qty') ? data['qty'] : 1,
      ordertime: time,
    );

    firestore
        .collection('users')
        .doc(user.uid)
        .collection('myOrder')
        .doc(brandId)
        .set(myOrder.toJson());
    // print('Data: ${brandId} \nData:${documentSnapshot['arrayimg']}');
  }

  // Cancel Order
  static Future<void> cancelorder(String brandId) async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .collection('myOrder')
        .doc(brandId)
        .get()
        .then((value) async {
      if (value.exists) {
        await firestore
            .collection('users')
            .doc(user.uid)
            .collection('myOrder')
            .doc(brandId)
            .delete();
      }
    });
  }

/************************************Authentication ***************************/
  // Sign In With Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("signInWithGoogle: ${e} ");
      
      return null;
    }
  }

  // Sign Up with Email
  Future<UserCredential?> signUpWithEmail(
      BuildContext context, Useremail, Userpassword) async {
    try {
      final Credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: Useremail, password: Userpassword)
          .then((user) async {
        // From here itself moving to home screen
        if (user != null) {
          print("User Detail : ${user.user}");
          Navigator.pop(context);
          if (await userExists()) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else {
            await createUser().then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            });
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        print('The Password provided is too weak');
        DialogsWidget.showFlushBar(
            context, "The Password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        print('The account already exist for that email.');
        DialogsWidget.showFlushBar(context, "The Email Id is already in use");
      }
    } catch (e) {
      print("signUpWithEmail: ${e} ");
      DialogsWidget.showFlushBar(
          context, "Something went wrong try again later");
      return null;
    }
  }

  // Signin with Email
  Future<UserCredential?> signInWithEmail(
      BuildContext context, String Useremail, String UserPassword) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: Useremail, password: UserPassword)
          .then((user) async {
        if (user != null) {
          Navigator.pop(context);
          print("User Detail : ${user.user}");
          if (await userExists()) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          } else {
            await createUser().then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            });
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      // print('Error gone ${e.code}');
      Navigator.pop(context);
      if (e.code == 'invalid-credential') {
        print('Invalid user name or password.');
        DialogsWidget.showFlushBar(context, "Invalid user name or password.");
      }
    } catch (e) {
      print("signInWithEmail: ${e} ");
      DialogsWidget.showFlushBar(
          context, "Something went wrong try again later");
      return null;
    }
  }

  // Logout
  Future<void> logoutFromDevice(
      BuildContext context, animationcontroller) async {
    DialogsWidget.showProgressBar(context, animationcontroller);
    await Apis.auth.signOut().then((value) async {
      await GoogleSignIn().signOut().then((value) {
        Navigator.pop(context);
        Apis.auth = FirebaseAuth.instance;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    });
  }
}
