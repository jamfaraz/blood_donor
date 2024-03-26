import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
            SizedBox(width: Get.width * .24),
            const Text(
              'About',
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Blood Bank',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade400),
            ),
            const SizedBox(height: 20),
            const Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
             Text(
              'Description:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade400),
            ),
            const Text(
              'Grocery App is your one-stop solution for all your grocery shopping needs. Find a wide range of products, place orders conveniently, and get them delivered to your doorstep.',
              style: TextStyle(fontSize: 16),
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
              'Email: yaarmuhammad00935@gmail.com',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'Phone: 0346523790',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Privacy Policy:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Read our Privacy Policy',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Terms of Service:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'View our Terms of Service',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
              Text(
              'Copy right Issues:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.red.shade400),
            ),
            const SizedBox(
              height: 6,
            ),
            const Row(
              children: [
                Text(
                  'Project Owner : ',
                  style: TextStyle(fontSize: 17, color: Colors.blue),
                ),
                 Text(
              'Yaar Muhammad',
              style: TextStyle(fontSize: 15, ),
            ),
              ],
            ),
             const Row(
               children: [
                 Text(
                  'Roll No. : ',
                  style: TextStyle(fontSize: 17,color: Colors.blue ),
                             ),
                             Text(
              'Bsf2005141',
              style: TextStyle(fontSize: 15, ),
            ),
               ],
             ),
          ],
        ),
      ),
    );
  }
}
