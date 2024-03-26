import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndialog/ndialog.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../controllers/profile_controller.dart';
import '../widgets/primary_textfield.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen({super.key});

  @override
  State<UpdateUserInfoScreen> createState() => _UpdateUserInfoScreenState();
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
    TextEditingController cityController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      setState(() {
        nameController.text = userData['username'] ?? '';
        emailController.text = userData['email'] ?? '';
        passwordController.text = userData['password'] ?? '';
        cityController.text = userData['city'] ?? '';
        contactController.text = userData['contact'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => profileController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 26,
                    ),
                    Row(children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
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
                      SizedBox(width: Get.width * .22),
                      const Text(
                        'Profile Setting',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    StreamBuilder(
                        stream: profileController.allUsers(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          return Column(
                              children: snapshot.data?.docs.map((e) {
                                    return Column(
                                      children: [
                                        e["userId"] ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? Column(
                                                children: [
                                                  Stack(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    children: [
                                                      Container(
                                                        height: 99,
                                                        width: 99,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      111),
                                                          child: profileController
                                                                      .image ==
                                                                  null
                                                              ? e["userId"] ==
                                                                      ''
                                                                  ? const Icon(
                                                                      Icons
                                                                          .person,
                                                                      size: 35,
                                                                    )
                                                                  : Image.network(
                                                                      e[
                                                                          'image'],
                                                                      fit: BoxFit
                                                                          .cover)
                                                              : Image.file(
                                                                  File(profileController
                                                                          .image!
                                                                          .path)
                                                                      .absolute,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: 2,
                                                        bottom: 1,
                                                        child: CircleAvatar(
                                                          radius: 16,
                                                          backgroundColor:
                                                              Colors.red.shade400,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                profileController
                                                                    .pickImage(
                                                                        context);
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              )),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    e['username'],
                                                    style: const TextStyle(
                                                      color: Color(0xFF494949),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    e['email'],
                                                    style: const TextStyle(
                                                      color: Color(0xFF494949),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox()
                                      ],
                                    );
                                  }).toList() ??
                                  []);
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
               

                        const Text(
                        'Full Name',
                        style: TextStyle(
                          color: Color(0xFF3D3D3D),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      PrimaryTextField(
                        controller: nameController,
                        text: 'Enter your name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.red.shade400,
                        ),
                      ),
                      10.heightBox,
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: Color(0xFF3D3D3D),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      PrimaryTextField(
                        controller: emailController,
                        text: 'Enter your email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.red.shade400,
                        ),
                      ),
                      // TextFormField(controller: emailController,),
                      10.heightBox,
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Color(0xFF3D3D3D),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      PrimaryTextField(
                          obsecure: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.red.shade400,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          prefixIcon: Icon(
                            Icons.password,
                            color: Colors.red.shade400,
                          ),
                          controller: passwordController,
                          text: 'Enter your password'),
                            10.heightBox,
                      const Text(
                        'City',
                        style: TextStyle(
                          color: Color(0xFF3D3D3D),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      PrimaryTextField(
                        controller: cityController,
                        text: 'Enter your city',
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Colors.red.shade400,
                        ),
                      ),  10.heightBox,
                      const Text(
                        'Contact',
                        style: TextStyle(
                          color: Color(0xFF3D3D3D),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      PrimaryTextField(
                        controller: contactController,
                        text: 'Enter your contact',
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.red.shade400,
                        ),
                      ),
                      ]),
                    const SizedBox(
                      height: 36
                    ),
                    InkWell(
                      onTap: () {
                        updateUserInfo();
                      },
                      child: Container(
                        height: 49,
                        width: Get.size.width,
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(44),
                        ),
                        child: const Center(
                          child: Text(
                            'Update',
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
    ));
  }

  void updateUserInfo() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text('Please wait'), title: null);
    try {
      progressDialog.show()
;      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'username': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'city': cityController.text,
        'contact': contactController.text,
      });
      Get.snackbar('Success', 'User information updated successfully');
      progressDialog.dismiss();
    } catch (error) {
      progressDialog.dismiss();

      Get.snackbar('Error', error.toString());
    }
  }
}
