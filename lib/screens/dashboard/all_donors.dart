import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../chat/chat_screen.dart';

class AllDonorsScreen extends StatefulWidget {
  const AllDonorsScreen({super.key});

  @override
  State<AllDonorsScreen> createState() => _AllDonorsScreenState();
}

class _AllDonorsScreenState extends State<AllDonorsScreen> {
  TextEditingController searchController = TextEditingController();
  String searchText = "";
//
//

  String selectedCategory = ''; // 0 represents no selection

  void selectExperience(years) {
    setState(() {
      selectedCategory = years;
    });
  }

  bool isSelected = false;

  List<String> experience = [
    'A+',
    'B+',
    'O+',
    'AB',
    'A-',
    'B-',
    'O-',
  ];

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
            SizedBox(width: Get.width * .2),
            const Text(
              'All Donors',
              textAlign: TextAlign.center,
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.heightBox,

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextFormField(
                    controller: searchController,
                    cursorColor: Colors.red,
                    decoration: InputDecoration(
                      hintText: 'Search for donors',
                      border: InputBorder.none,
                      prefixIcon: (searchText.isEmpty)
                          ? const Icon(Icons.search,color: Colors.red,)
                          : IconButton(
                              icon: const Icon(Icons.clear,color: Colors.red,),
                              onPressed: () {
                                searchText = '';
                                searchController.clear();
                                setState(() {});
                              },
                            ),
                      hintStyle: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    }),
              ),

              // const SizedBox(
              //   height: 12,
              // ),

              const SizedBox(height: 24),
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = '';
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(33),
                            color: Colors.black),
                        height: 44,
                        width: 59,
                        child: const Center(
                            child: Text(
                          'All',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: experience.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                selectExperience(experience[index]);
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color:
                                      //  isSelected==true
                                      //     ? Colors.grey.shade400
                                      //     :
                                      Colors.redAccent,
                                ),
                                height: 30,
                                width: 59,
                                child: Center(
                                    child: Text(
                                  experience[index],
                                  style: const TextStyle(
                                      color:
                                          //  isSelected
                                          //     ? Colors.white
                                          //     :
                                          Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                height: 34,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFD3D3D3)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  selectedCategory == ''
                      ? 'All Donors'
                      : 'Donors with $selectedCategory blood group',
                  style: const TextStyle(
                    color: Color(0xFF535353),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 14),
              StreamBuilder(
                  stream: selectedCategory == ''
                      ? FirebaseFirestore.instance
                          .collection('donors')
                          .orderBy('username')
                          .startAt([searchText.toUpperCase()]).endAt(
                              ['$searchText\uf8ff']).snapshots()
                      : FirebaseFirestore.instance
                          .collection('donors')
                          .orderBy('username')
                          .where('category', isEqualTo: selectedCategory)
                          .startAt([searchText.toUpperCase()]).endAt(
                              ['$searchText\uf8ff']).snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: Padding(
                        padding: EdgeInsets.only(top: 233),
                        child: CircularProgressIndicator(),
                      ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return  Center(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 233),
                        child: Text(
                          'No donors Registered yet with $selectedCategory ',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                        ),
                      ));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          final e = snapshot.data!.docs[index];
                          if (e["username"]
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase())) {
                          
                            return Card(
                                shadowColor: Colors.black,
                                color: Colors.white,
                                elevation: 13,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 76,
                                              decoration: ShapeDecoration(
                                                image: DecorationImage(
                                                  image:
                                                      NetworkImage(e['image']),
                                                  fit: BoxFit.cover,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 2),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              e['username'],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              e['category'], // Replace with your experience text
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                GestureDetector(
                                          onTap: () {
                                            Get.to(() => ChatScreen(
                                                  fcmToken: e['fcmToken'],
                                                  name: e['username'],
                                                  image: e['image'],
                                                  uid: e['donorId'],
                                                  groupId: FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                ));
                                          },
                                          child: Container(
                                          padding: EdgeInsets.all(4),
                                            height: 28,
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(44),
                                            ),
                                            child: const Center(
                                              child: Text(
                                                'Chat Now',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                                    
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                       
                                      ],
                                    ),
                                  ),
                                ));
                          } else {
                            return const SizedBox();
                          }
                        },
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
