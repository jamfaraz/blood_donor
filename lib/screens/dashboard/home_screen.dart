// ignore_for_file: sized_box_for_whitespace

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
    tabController.addListener(() {
      setState(() {});
    });
  }

  String searchText = "";
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                                      NetworkImage(e['image']),
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Hello,',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF0C253F),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      e['username'],
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF5A5A5A),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
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
                      }),
                ],
              ),
              const Divider(),
              8.heightBox,
              // TextFormField(
              //   controller: searchController,
              //   cursorColor: Colors.green,
              //   decoration: InputDecoration(
              //     contentPadding: EdgeInsets.symmetric(
              //       vertical: MediaQuery.of(context).size.width * 0.030,
              //     ),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: const BorderSide(
              //         color: Colors.black45,
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8),
              //       borderSide: const BorderSide(
              //         color: Colors.black,
              //       ),
              //     ),
              //     prefixIcon: (searchText.isEmpty)
              //         ? const Icon(Icons.search)
              //         : IconButton(
              //             icon: const Icon(Icons.clear),
              //             onPressed: () {
              //               searchText = '';
              //               searchController.clear();
              //               setState(() {});
              //             },
              //           ),
              //     hintText: 'Search by name',
              //     hintStyle: const TextStyle(color: Colors.green),
              //     border: InputBorder.none,
              //   ),
              //   onChanged: (value) {
              //     setState(() {
              //       searchText = value;
              //     });
              //   },
              // ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('items')
                    // .limit(4)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        ' data is not available',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.green),
                      ),
                    );
                  } else {
                    final documents = snapshot.data!.docs;

                    return SizedBox(
                      height: Get.height * .22,
                      child: Swiper(
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          final data =
                              documents[index].data() as Map<String, dynamic>;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(14),

                              // image: DecorationImage(image: NetworkImage(data['image']),fit: BoxFit.contain),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  data['image'],
                                  fit: BoxFit.cover,
                                  height: Get.height * .2,
                                  width: Get.width * .86,
                                )),
                          );
                        },
                        allowImplicitScrolling: true, autoplay: true,
                        pagination: const SwiperPagination(),
                        // control: const SwiperControl(),
                      ),
                    );
                  }
                },
              ),
              12.heightBox,
              TabBar(
                  controller: tabController,
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  tabs: [
                    TabBarItem(
                      title: 'Fruits',
                      isSelected: tabController.index == 0,
                      selectedColor: Colors.green,
                    ),
                    TabBarItem(
                      title: 'Vegetables',
                      isSelected: tabController.index == 1,
                      selectedColor: Colors.green,
                    ),
                  ]),
              Expanded(
                child: TabBarView(
                  controller: tabController,

                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Popular Fruits',
                                  style: TextStyle(
                                    color: Color(0xFF3D3D3D),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Get.to(() => const AllFruits());
                                  },
                                  child: const Text(
                                    'View all',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          _buildAppointmentsStream(category: 'Fruits')
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Popular Vegetables',
                                  style: TextStyle(
                                    color: Color(0xFF3D3D3D),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Get.to(() => const AllVegetables());
                                  },
                                  child: const Text(
                                    'View all',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          _buildAppointmentsStream(category: 'Vegetables')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentsStream({required String category}) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('items')
          .limit(4)
          .where(
            'category',
            isEqualTo: category,
          )
          .snapshots(),
      //
      //

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data?.docs.length ?? 0,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 12, crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: Container(
                    height: 100,
                    width: 133,
                    color: Colors.white,
                  ));
            },
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 166),
              child: Text(
                'data is not available',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.green),
              ),
            ),
          );
        } else {
//

          return Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length ?? 0,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 12, crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  final e = snapshot.data!.docs[index];

                  return GestureDetector(
                    onTap: () {
                      // Get.to(() => ProductDetailPage(
                      //     image: e['image'],
                      //     price: e['price'],
                      //     quantity: e['quantity'],
                      //     category: e['category'],
                      //     address: e['address'],
                      //     title: e['title']));
                    },
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 224, 224, 224),
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 104,
                                width: Get.width * .43,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(e['image']),
                                        fit: BoxFit.cover)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e["title"],
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text('${e["price"]}/ kg'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          );
        }
      },
    );
  }
}

class TabBarItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color selectedColor;

  const TabBarItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.size.width,
      height: 42,
      decoration: ShapeDecoration(
        color: isSelected ? selectedColor : Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1,
              color: isSelected ? Colors.white : const Color(0xFFB3B3B3)),
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFFB3B3B3),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
