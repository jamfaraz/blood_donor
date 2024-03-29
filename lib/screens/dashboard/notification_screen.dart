import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:timeago/timeago.dart' as timeAgo;

import '../../controllers/data_controller.dart';

class UserNotificationScreen extends StatefulWidget {
  const UserNotificationScreen({
    super.key,
  });

  @override
  State<UserNotificationScreen> createState() => _UserNotificationScreenState();
}

class _UserNotificationScreenState extends State<UserNotificationScreen> {
  DataController dataController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                height: 30,
                width: 30,
                decoration:  BoxDecoration(
                  color: Colors.red.shade400,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: Get.width * .2),
            const Text(
              'Notifications',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        // elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              StreamBuilder<QuerySnapshot>(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(
                          top: 244,
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 233),
                        child: Center(
                          child:  Text(
                            'You have not any notification yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.redAccent),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          DateTime date;
                          try {
                            date = data.get('time').toDate();
                          } catch (e) {
                            date = DateTime.now();
                          }
                          return Column(
                            children: [
                              InkWell(
                                // onDoubleTap: () {
                                //    Get.to(()=> ChatScreen(
                                //       fcmToken: data['fcmToken'],
                                //                   name: data['name'],
                                //                   image: data['image'],
                                //                   uid: data['userId'],
                                //                   groupId: FirebaseAuth.instance
                                //                       .currentUser!.uid,

                                    
                                //   ));
                                // },
                                onLongPress: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text("Are you sure ?"),
                                            content: const Text(
                                                "Click Confirm if you want to delete this item"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel")),
                                              TextButton(
                                                  onPressed: () async {
                                                    dataController
                                                        .deleteNotification(data.id);
                                                    Get.back();
                                                  },
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ))
                                            ],
                                          ));
                                },
                                child: Card(
                                  shadowColor: Colors.black,
                                  color: Colors.white,
                                  elevation: 13,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: ListTile(
                                      onTap: () {},
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            NetworkImage(data['image']),
                                      ),
                                      title: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${data['name']} ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '${data['message']}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      subtitle: Text(
                                        timeAgo.format(date),
                                        // DateFormat.Hm().format(data['time'].toDate()),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: snapshot.data?.docs.length ?? 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      );
                    }
                  },
                  stream: dataController
                      .getNotificatiom(FirebaseAuth.instance.currentUser!.uid)),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
