import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final String text;
  final bool obsecure;
  final TextEditingController controller;

  const PrimaryTextField(
      {super.key,
      required this.prefixIcon,
      required this.controller,
      required this.text, this.suffixIcon, this.obsecure=false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
         obscureText: obsecure,
      controller: controller,
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
        ), focusedBorder: OutlineInputBorder(
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
          suffixIcon: suffixIcon,
          isDense: true,
          prefixIcon: prefixIcon,
          hintText: text,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(33))),
        
      
        
      
    );
  }
}
