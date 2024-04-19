import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';


import '../../../controllers/auth_controller.dart';

import '../widgets/primary_textfield.dart';
import 'data_screen.dart';
import 'forgot_password_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  AuthController authController = Get.put(AuthController());
  bool loading = false;
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
 
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                36.heightBox,
                 Text(
                  'Welcome Back',
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
                  'Welcome Back! Please Enter Your Details.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                24.heightBox,
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
                      height: 8,
                    ),
                    PrimaryTextField(
                        obsecure: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                              color: Colors.red.shade400,
                              ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        prefixIcon:  Icon(
                          Icons.password,
                          color: Colors.red.shade400,
                        ),
                        controller: passwordController,
                        text: 'Enter your password'),
                    26.heightBox,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => const ForgotPasswordScreen());
                          },
                          child:  Text(
                            'Forgot password',
                            style: TextStyle(
                              color: Colors.red.shade400,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    40.heightBox,
                    Center(
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () async {
                              String email = emailController.text.trim();
                              String password = passwordController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Please enter all details",
                                );
                              } else {
                                await authController.loginUser(
                                    context, email, password);
                                // showModal();
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 349 * 12,
                              decoration: BoxDecoration(
                                color:Colors.red.shade400,
                                borderRadius: BorderRadius.circular(44),
                              ),
                              child: const Center(
                                child: Text(
                                  'Sign in',
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
                    Get.to(() => const DataScreen());
                  },
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don’t have an account? ',
                        style: TextStyle(
                          color: Color(0xFF828A89),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Sign Up for free',
                        style: TextStyle(
                          color: Colors.red.shade500,
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
        ),
      ),
    );
  }

 
}
