import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  AuthController authController = Get.put(AuthController());
  bool loading = false;
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  SizedBox(width: Get.width * .2),
                  const Text(
                    'Forgot Password ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: Get.height * .04,
                ),
                 Text(
                  'Reset your password',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                20.heightBox,
                const Padding(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  child: Text(
                    "Don't worry if you forgot your Password, we have a solution for you, Just enter your assosiated email here to get a password reset link",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF828A89),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                33.heightBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        color: Color(0xFF3D3D3D),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
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
                    40.heightBox,
                    Center(
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              if (emailController.text.isEmpty) {
                                Get.snackbar('Error', 'Please enter the email');
                              } else {
                                authController.resetmypassword(
                                    emailController.text, context);
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 349 * 12,
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Text(
                                  'Reset',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
