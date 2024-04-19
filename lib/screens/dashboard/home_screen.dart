import 'package:blood_donor/screens/dashboard/all_donors.dart';
import 'package:blood_donor/screens/dashboard/nearby_donors.dart';
import 'package:blood_donor/screens/dashboard/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = "";
  TextEditingController searchController = TextEditingController();

  List<DocumentSnapshot> _lawyers = [];

  Future<void> _fetchNearestDonors() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double userLatitude = position.latitude;
    double userLongitude = position.longitude;

    var snapshots = await FirebaseFirestore.instance
        .collection('donors')
        .limit(4)
        .orderBy('username')
        .startAt([searchText.toUpperCase()]).endAt(['$searchText\uf8ff']).get();
    setState(() {
      _lawyers = snapshots.docs.where((doc) {
        double lawyerLatitude = doc['latitude'];
        double lawyerLongitude = doc['longitude'];
        double distance = Geolocator.distanceBetween(
          userLatitude,
          userLongitude,
          lawyerLatitude,
          lawyerLongitude,
        );
        return distance <= 25000; // 25 km in meters
      }).toList();
    });
  }

  @override
  void initState() {
    _fetchNearestDonors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Column(
                                children: snapshot.data?.docs.map((e) {
                                      return Column(
                                        children: [
                                          e["userId"] ==
                                                  FirebaseAuth
                                                      .instance.currentUser?.uid
                                              ? Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              e['image']),
                                                    ),
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'Hello recipient,',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF0C253F),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        Text(
                                                          e['username'],
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF5A5A5A),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox()
                                        ],
                                      );
                                    }).toList() ??
                                    []);
                          }
                        }),
                    IconButton(
                      onPressed: () {
                        Get.to(() => const UserNotificationScreen());
                      },
                      icon: const Icon(
                        Icons.notification_add,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                10.heightBox,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  width: 327 * 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          cursorColor: Colors.red,
                          decoration: InputDecoration(
                            prefixIcon: (searchText.isEmpty)
                                ? const Icon(
                                    Icons.search,
                                    color: Colors.red,
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      searchText = '';
                                      searchController.clear();
                                      setState(() {});
                                    },
                                  ),
                            hintText: 'Search by name',
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              // color: const Color(0xFF353535),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });
                          },
                        ),
                      ),
                      // Image.asset(
                      //   'assets/filter.png',
                      //   height: 20,
                      //   width: 20,
                      // ),
                    ],
                  ),
                ),
                18.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nearby Donors",
                      style: TextStyle(
                        color: Color(0xFF474747),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const NearbyDonorsScreen());
                      },
                      child: const Text(
                        "View all",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                5.heightBox,
                SizedBox(
                  height: 128,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('donors')
                          .limit(4)
                          .orderBy('username')
                          .startAt([searchText.toUpperCase()]).endAt(
                              ['$searchText\uf8ff']).snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: CircularProgressIndicator(),
                          ));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'No donors Registered yet',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                            ),
                          ));
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: _lawyers.length,
                            itemBuilder: (context, index) {
                              final e = _lawyers[index];
                              return Column(
                                children: [
                                  Card(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                      horizontal: 10,vertical: 10
                                      ),
                                      height: 120,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: Get.height*.12,
                                            width: Get.width*.22,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                e['image'],
                                                fit: BoxFit.cover,
                                                height: 75,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6, top: 9),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      e['username'],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    // 5.widthBox,
                                                    // Text(
                                                    //   '4.7',
                                                    //   style: GoogleFonts.poppins(
                                                    //     color: Colors.black,
                                                    //     fontSize: 12,
                                                    //     fontWeight: FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    // const Icon(
                                                    //   Icons.star,
                                                    //   color: Colors.amber,
                                                    // ),
                                                  ],
                                                ),
                                                2.heightBox,
                                                Text(
                                                  e['category'],
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 22,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'City',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 33,
                                                    ),
                                                    Text(
                                                      e['city'],
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "All donors",
                      style: TextStyle(
                        color: Color(0xFF474747),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const AllDonorsScreen());
                      },
                      child: const Text(
                        "View all",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 128,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('donors')
                          .limit(4)
                          .orderBy('username')
                          .startAt([searchText.toUpperCase()]).endAt(
                              ['$searchText\uf8ff']).snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: CircularProgressIndicator(),
                          ));
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'No donors Registered yet',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                            ),
                          ));
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            // itemCount:snapshot.data!.docs.length
                            // <
                            //                         3
                            //                     ? snapshot.data!.docs.length
                            //                     : 3,
                            itemCount: snapshot.data?.docs.length ?? 0,

                            itemBuilder: (context, index) {
                              final e = snapshot.data!.docs[index];
                              return Card(
                                color: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10,vertical: 10
                                      ),
                                      height: 120,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: Get.height*.12,
                                            width: Get.width*.22,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                e['image'],
                                                fit: BoxFit.cover,
                                                height: 75,
                                              ),
                                            ),
                                          ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6, top: 9),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  e['username'],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                // 5.widthBox,
                                                // Text(
                                                //   '4.7',
                                                //   style: GoogleFonts.poppins(
                                                //     color: Colors.black,
                                                //     fontSize: 12,
                                                //     fontWeight: FontWeight.bold,
                                                //   ),
                                                // ),
                                                // const Icon(
                                                //   Icons.star,
                                                //   color: Colors.amber,
                                                // ),
                                              ],
                                            ),
                                            2.heightBox,
                                            Text(
                                              e['category'],
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 10,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 22,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'City',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 33,
                                                ),
                                                Text(
                                                  e['city'],
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }),
                ),
                20.heightBox,
                20.heightBox,
                Stack(
                  children: [
                    Container(
                      height: Get.height * .22,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Chat with experts ',
                                  style: TextStyle(
                                    color: Color(0xFFF6FAFC),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  'Access to Expertise',
                                  style: TextStyle(
                                    color: Color(0xFFF6FAFC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Text(
                                  'Convenient',
                                  style: TextStyle(
                                    color: Color(0xFFF6FAFC),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Text(
                                  'Time-Saving',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const Text(
                                  'Confidential',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                10.heightBox,
                                Container(
                                  height: 26,
                                  width: 93,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Chat Now',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    10.widthBox,
                    Positioned(
                      right: -92,
                      top: 2,
                      left: 190,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/person.png',
                          width: 244,
                          height: 207,
                          fit: BoxFit.cover,
                        ),
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
