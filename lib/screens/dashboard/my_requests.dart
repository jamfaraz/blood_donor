import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({super.key});

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  String searchText = "";
  TextEditingController searchController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, centerTitle: true,
        title: const Text(
          'My Posts',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        // elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('posts')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    // .orderBy('timestamp',descending: true)

                    .snapshots(),
                //
                //

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Padding(
                      padding: EdgeInsets.only( top: Get.height * .4),
                      child: const Center(child:  CircularProgressIndicator()),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: Get.height * .4),
                      child: const Center(
                        child: Text(
                          'You have not any post yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.redAccent),
                        ),
                      ),
                    );
                  } else {
                    //

                    return Column(
                      children: [
                        const SizedBox(
                          height: 6,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length ?? 0,
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index];

                            return Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(data['image']),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          data['name'],
                                          style: const TextStyle(
                                            color: Color(0xFF474747),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      "Are you sure ?"),
                                                  content: const Text(
                                                      "Click Confirm if you want to delete this item"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Cancel")),
                                                    TextButton(
                                                        onPressed: () async {
                                                          await profileController
                                                              .deletePost(
                                                                  data.id);
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
                                      child: const Text(
                                        "delete",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Card(
                                  shadowColor: Colors.black,
                                  color: Colors.white,
                                  elevation: 13,
                                  child: Container(
                                    // height: 166,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                data['post'],
                                              ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
