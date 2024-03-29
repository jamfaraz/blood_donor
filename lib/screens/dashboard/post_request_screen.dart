import 'dart:async';

import 'package:blood_donor/controllers/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/profile_controller.dart';

class PostRequestScreen extends StatefulWidget {
  const PostRequestScreen({super.key});

  @override
  State<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends State<PostRequestScreen> {
  String name = "";

  ProfileController profileController = Get.put(ProfileController());

  TextEditingController postController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  final _categories = <String>[
    'A+',
    'B+',
    'O+',
    'AB',
    'A-',
    'B-',
    'O-',
  ];
           
  String? _category;

  void addPost(
      {required String post,
      required String address,
      required String category,
      required String contact}) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text('Please wait'), title: null);
    try {
      progressDialog.show();

      progressDialog.show();
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;
      var uuid = const Uuid();
      var myId = uuid.v6();
      DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final data = document.data()!;
      String userName = data['username'];
      String image = data['image'];
      String fcmToken = data['fcmToken'];
      //
      //
      await FirebaseFirestore.instance.collection('posts').doc(myId).set({
        'postId': myId,
        'userId': uid,
        'username': userName,
        'contact': contact,
        'image': image,
        'category': category,
        'address': address,
        'fcmToken': fcmToken,
        'post': post,
        'time': DateTime.now(),
      });

      progressDialog.dismiss();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('donors').get();
      for (var doc in querySnapshot.docs) {
        String fcmToken = doc['fcmToken'];

        LocalNotificationService.sendNotification(
            title: '$userName added a new post',
            message: postController.text,
            token: fcmToken);
      }
      Fluttertoast.showToast(msg: 'Your post added sucessfully');
    } catch (e) {
      progressDialog.dismiss();

      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      Fluttertoast.showToast(msg: 'Post deleted successfully.');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting post: $e');
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   Timer(const Duration(minutes: 10), () {
  //     FirebaseFirestore.instance
  //         .collection('posts')
  //         .get()
  //         .then((querySnapshot) {
  //       for (var doc in querySnapshot.docs) {
  //         deletePost(doc.id);
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, centerTitle: true,
          title: const Text(
            'Add post',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          // elevation: 1,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 28,
                ),
                const Text(
                  'Decription',
                  style: TextStyle(
                    color: Color(0xFF3D3D3D),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: postController,
                  cursorColor: Colors.red,
                  maxLines: 6,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.030,
                          horizontal: 9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF828A89),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      isDense: true,
                      hintText: 'Enter your post',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Address',
                  style: TextStyle(
                    color: Color(0xFF3D3D3D),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: addressController,
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.030,
                          horizontal: 9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF828A89),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      isDense: true,
                      hintText: 'Enter your address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'Contact',
                  style: TextStyle(
                    color: Color(0xFF3D3D3D),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                TextFormField(
                  controller: contactController,
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.030,
                          horizontal: 9),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintStyle: const TextStyle(
                        color: Color(0xFF828A89),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      isDense: true,
                      hintText: 'Enter your contact',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Blood group',
                  style: TextStyle(
                    color: Color(0xFF3D3D3D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.030,horizontal: 9
                    ),
                    // prefixIcon: const Icon(Icons.category, color: Colors.black),
                    hintText: 'Select group',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black45,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  value: _category,
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  items: _categories
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(
                  height: Get.height * .12,
                ),
                InkWell(
                  onTap: () async {
                    if (postController.text.isEmpty ||
                        contactController.text.isEmpty ||
                        _category.toString().isEmpty ||
                        addressController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please enter all details",
                      );
                    } else {
                      addPost(
                          post: postController.text,
                          address: addressController.text,
                          category: _category.toString(),
                          contact: contactController.text);
                          // 
                          // 
                           postController.clear();
                    addressController.clear();
                    contactController.clear();
                      //
                      //
                    }
                   
                  },
                  child: Container(
                    height: 49,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(44),
                    ),
                    child: const Center(
                      child: Text(
                        'Add Post',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
