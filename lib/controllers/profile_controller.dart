import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../screens/auth/sign_in_screen.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Stream<QuerySnapshot<Map<String, dynamic>>> allUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

  final picker = ImagePicker();
  XFile? _image;
  XFile? get image => _image;

  Future pickGalleryimage() async {
    isLoading.value = true;
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadProfilePicture();
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  Future pickCameraimage() async {
    isLoading.value = true;

    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadProfilePicture();
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void pickImage(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 120,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    pickCameraimage();
                    Get.back();
                  },
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.green,
                  ),
                  title: const Text('Camera'),
                ),
                ListTile(
                  onTap: () {
                    pickGalleryimage();
                    Get.back();
                  },
                  leading: const Icon(
                    Icons.image,
                    color: Colors.green,
                  ),
                  title: const Text('Gallery'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> uploadProfilePicture() async {
    isLoading.value = true;
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref('profileImage/');
      await ref.putFile(File(image!.path).absolute);
      String imageUrl = await ref.getDownloadURL();
      // print("Image URL : " + imageUrl);
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'image': imageUrl.toString()}).then((value) {
        Fluttertoast.showToast(msg: 'Profile updated');
        isLoading.value = false;
        _image = null;
      });
      isLoading.value = false;

      return imageUrl;
    } on FirebaseException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }

    return '';
  }

//
//

  logOut() async {
    await FirebaseAuth.instance.signOut();
    Get.to(() => const SigninScreen());
  }

  //
  //
  Future<String> uploadProfile(
    String email,
    String fileName,
    String filePath,
  ) async {
    // File file = File(FilePath);
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref('$email/').child(fileName);
      await ref.putFile(File(filePath));
      String imageUrl = await ref.getDownloadURL();
      // print("Image URL : " + imageUrl);
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
      return imageUrl;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return '';
  }

//
//
  Future deletePost(String id) async {
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(id)
        .delete()
        .then((value) {});
  }
}
