import 'package:blood_donor/controllers/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';

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

  void addPost({required String post, required String address}) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text('Please wait'), title: null);
    try {
      progressDialog.show();

      DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      final data = document.data()!;
      String userName = data['username'];
      String image = data['image'];
      //
      //
      setState(() {
        name=userName;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('posts')
          .add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'name': userName,
        'post': post,
        'image': image,
        'address': address,
        'time': DateTime.now(),
      });
      
      progressDialog.dismiss();
      Fluttertoast.showToast(msg: 'Your post added sucessfully');
    } catch (e) {
      progressDialog.dismiss();

      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

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
                  height: 8,
                ),
                TextFormField(
                  controller: postController,
                  cursorColor: Colors.red,
                  maxLines: 6,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.030,
                          horizontal: 6),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
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
                          borderRadius: BorderRadius.circular(4))),
                ),
                const SizedBox(
                  height: 12,
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
                  height: 8,
                ),
                TextFormField(
                  controller: addressController,
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.030,
                          horizontal: 6),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Colors.black45,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
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
                          borderRadius: BorderRadius.circular(4))),
                ),
                SizedBox(
                  height: Get.height * .16,
                ),
                InkWell(
                  onTap: () async {
                    if (postController.text.isEmpty ||
                        addressController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please enter all details",
                      );
                    } else {
                      addPost(
                          post: postController.text,
                          address: addressController.text);
                    }
                    postController.clear();
                    addressController.clear();

                    QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('donors')
                        .get();
                    for (var doc in querySnapshot.docs) {
                      String fcmToken = doc['fcmToken'];

                      LocalNotificationService.sendNotification(
                          title: '$name added a new post',
                          message: postController.text,
                          token: fcmToken);
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
