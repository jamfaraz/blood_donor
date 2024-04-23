import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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
                decoration: BoxDecoration(
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
              'Need Help',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        // elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Help?',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade400),
            ),
            const SizedBox(height: 20),
            Text(
              'Contact Us:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade400),
            ),
            const Text(
              'If you have any questions, concerns, or feedback, feel free to reach out to us.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Email: support@bloodPoint.com',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Phone: 03076300935',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'FAQs:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade400),
            ),
            const Text(
              '1. How do I get Blood?',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'You have a Post Request option in botom nevigation bar go to there and creat post and donor will accept you request and contect with you.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '2. How can I contect Directly?',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Sure In Search opetion you will see the nearest persons if they are related to your blood catagory then you can contect with them.',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '3. How do I update my profile?',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'You can update your profile information by navigating to the "Edit Profile" section in the app.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
