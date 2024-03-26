import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;
import 'package:uuid/uuid.dart';

class DataController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;


 
//
//
  Stream<QuerySnapshot> getNotificatiom(String uuidToRetrieve) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: uuidToRetrieve)
        .orderBy('time', descending: true)

        .snapshots();
  }



  
     
//
//
  Future<void> createNotification({
    required String userId,
    required String message,
  }) async {
    var uuid = const Uuid();
    var myId = uuid.v6();



 DocumentSnapshot<Map<String, dynamic>> document=await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
    final data = document.data()!;
      String userName = data['username'] ;
      String userProfileImage = data['image'] ;


    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(myId)
          .set({
        'notificationUid': FirebaseAuth.instance.currentUser!.uid,
        'userId': userId,
        'image': userProfileImage,
        'message': message,
        'name': userName,
        'time': DateTime.now()
      });
    } catch (e) {
      if (kDebugMode) {
        print(" Error: ${e.toString()}");
      }
    }
  }

//
//
  Future<void> deleteNotification(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(id)
          .delete()
          .then((value) {});
    } catch (e) {
      Get.snackbar('Error', 'Error deleting document: $e');
    }
  }
  //

//
  Future<String> uploadImageToFirebase(File file) async {
    String fileUrl = '';
    String fileName = Path.basename(file.path);
    var reference = FirebaseStorage.instance.ref().child('myfiles/$fileName');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then((value) {
      fileUrl = value;
    });
    if (kDebugMode) {
      print("Url $fileUrl");
    }
    return fileUrl;
  }
//
//

 
}
