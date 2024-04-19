import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../controllers/auth_controller.dart';

import '../widgets/primary_textfield.dart';
import 'sign_in_screen.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  AuthController authController = Get.put(AuthController());
  // LocalNotificationService localNotificationService =
  //     LocalNotificationService();
  bool loading = false;

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.red.shade400,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    'Let’s create account together',
                    style: TextStyle(
                      color: Color(0xFF828A89),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  14.heightBox,
                  Center(
                    child: Obx(
                      () => authController.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : GestureDetector(
                              onTap: () async {
                                authController.pickImage(context);
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  border: Border.all(color: Colors.black12),
                                  color:
                                      const Color.fromARGB(255, 231, 231, 231),
                                  image: authController.image == null
                                      ? const DecorationImage(
                                          image: AssetImage(
                                            'assets/gallery.png',
                                          ),
                                          
                                        )
                                      : DecorationImage(
                                          image: FileImage(
                                            File(authController.image!.path)
                                                .absolute,
                                          ),
                                          fit: BoxFit.cover),
                                ),
                              ),
                            ),
                    ),
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
                        TextFormField(
                      controller: emailController,
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.width * 0.030,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(33),
                            borderSide: const BorderSide(
                              color: Colors.black45,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(33),
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
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.red,
                          ),
                          hintText: 'Enter your email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(33))),
                              keyboardType: TextInputType.emailAddress,

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
                    TextFormField(
                      controller: contactController,
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.width * 0.030,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(33),
                            borderSide: const BorderSide(
                              color: Colors.black45,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(33),
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
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.red,
                          ),
                          hintText: 'Enter your contact',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(33))),
                              keyboardType: TextInputType.number,
                    ),
                     

                      38.heightBox,
                      Center(
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () async {
                                try {
                                  String name = nameController.text.trim();
                                  String email = emailController.text.trim();
                                  String city = cityController.text.trim();
                                  String contact =
                                      contactController.text.trim();

                                  String password =
                                      passwordController.text.trim();

                                  if (authController.image == null ||
                                      name.isEmpty ||
                                      emailController.text.trim().isEmpty ||
                                      password.isEmpty) {
                                    Get.snackbar(
                                      "Error",
                                      "Please enter all details",
                                    );
                                  } else {
                                    authController.createUser(
                                        email: email,
                                        name: name,
                                        password: password,
                                        city: city,
                                        contact: contact,
                                        context: context);

                                    // showModal();
                                  }
                                } catch (e) {
                                  Get.snackbar(
                                    "Error",
                                    e.toString(),
                                  );
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 349 * 12,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(44),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const SigninScreen());
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Color(0xFF828A89),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Sign in',
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
