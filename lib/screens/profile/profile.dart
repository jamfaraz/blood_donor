import 'package:blood_donor/screens/profile/my_requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../controllers/profile_controller.dart';
import 'about_screen.dart';
import 'edit_profile_screen.dart';
import 'help_screen.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileController profileController = Get.put(ProfileController());
  String image = '';
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Obx(
      () => profileController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          22.heightBox,
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'Profile',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: height * 0.8,
                            width: double.infinity,
                            color: Colors.white,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              double innerheight = constraints.maxHeight;
                              double innerwidth = constraints.maxWidth;
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 1,
                                    child: Container(
                                      height: innerheight * 0.89,
                                      width: innerwidth,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(60),
                                          topRight: Radius.circular(60),
                                        ),
                                        color: Color(0xFFF7F7F7),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: height * 0.02,
                                    right: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                      ),
                                      child: Column(
                                        children: [
                                          StreamBuilder(
                                              stream:
                                                  profileController.allUsers(),
                                              builder: (context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                return Column(
                                                    children:
                                                        snapshot.data?.docs
                                                                .map((e) {
                                                              return Column(
                                                                children: [
                                                                  e["userId"] ==
                                                                          FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .uid
                                                                      ? Column(
                                                                          children: [
                                                                            Container(
                                                                              height: 99,
                                                                              width: 99,
                                                                              decoration: const BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                              ),
                                                                              child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(111),
                                                                                  child: e["userId"] == ''
                                                                                      ? const Icon(
                                                                                          Icons.person,
                                                                                          size: 35,
                                                                                        )
                                                                                      : Image.network(e['image'], fit: BoxFit.cover)),
                                                                            ),
                                                                            Text(
                                                                              e['username'],
                                                                              style: const TextStyle(
                                                                                color: Color(0xFF494949),
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              e['email'],
                                                                              style: const TextStyle(
                                                                                color: Color(0xFF494949),
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )
                                                                      : const SizedBox()
                                                                ],
                                                              );
                                                            }).toList() ??
                                                            []);
                                              }),
                                          34.heightBox,
                                          Container(
                                            height: 42,
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                            ),
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Get.to(() =>
                                                    const UpdateUserInfoScreen());
                                              },
                                              child: Row(
                                                children: [
                                                   Icon(
                                                      Icons.account_circle,
                                                color: Colors.red.shade400,
                                                      ),
                                                  20.widthBox,
                                                  const Text(
                                                    'Edit Profile',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                         
                                      
                                          10.heightBox,
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(()=>const HelpScreen());
                                            },
                                            child: Container(
                                              height: 42,
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                children: [
                                                   Icon(Icons.help,
                                                color: Colors.red.shade400,
                                                  ),
                                                  20.widthBox,
                                                  const Text(
                                                    'Help',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          10.heightBox,
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(()=> const AboutScreen());
                                            },
                                            child: Container(
                                              height: 42,
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                children: [
                                                   Icon(Icons.history,
                                                color: Colors.red.shade400,
                                                  ),
                                                  20.widthBox,
                                                  const Text(
                                                    'About',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                            10.heightBox,
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(()=> const MyRequestScreen());
                                            },
                                            child: Container(
                                              height: 42,
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                              ),
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: Row(
                                                children: [
                                                   Icon(Icons.payment_outlined,
                                                color: Colors.red.shade400,
                                                  ),
                                                  20.widthBox,
                                                  const Text(
                                                    'My requests',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          80.heightBox,
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: const Text(
                                                            "Are you sure ?"),
                                                        content: const Text(
                                                            "Click Confirm if you want to Log out of the app"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "Cancel")),
                                                          TextButton(
                                                              onPressed: () {
                                                                profileController
                                                                    .logOut();

                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                "Confirm",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ))
                                                        ],
                                                      ));
                                            },
                                            child: Container(
                                              height: 49,
                                              width: 312,
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade400,
                                                borderRadius:
                                                    BorderRadius.circular(44),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Logout',
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
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
