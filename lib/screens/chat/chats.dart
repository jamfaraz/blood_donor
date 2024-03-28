
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chat_screen.dart';


class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {

  
  String searchText = "";
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title:   const Text(
                    'Chats',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.024, vertical: Get.height * 0.01),
          child: Column(
            children: [
              // Center(
              //   child: Text(
              //     'Recent',
              //     style: kBody1MediumBlue,
              //   ),
              // ),
              11.heightBox,
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
              
              const SizedBox(height: 10),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .orderBy('timeStamp', descending: true)
                      // .orderBy('username')
                      //     .startAt([searchText.toUpperCase()]).endAt(
                      //         ['$searchText\uf8ff'])
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.only(top: 255),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    QuerySnapshot chatSnapshot = snapshot.data as QuerySnapshot;
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: chatSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          final chatData = snapshot.data?.docs[index].data()
                              as Map<String, dynamic>;
                          dynamic group = chatData['group'];
                          List<dynamic> groupIds = group.toList();

                          String targetUserId1 = groupIds[0];
                          String targetUserId2 =
                              groupIds.length > 1 ? groupIds[1] : "";
                          groupIds
                              .remove(FirebaseAuth.instance.currentUser!.uid);
                          return targetUserId1 ==
                                      FirebaseAuth.instance.currentUser!.uid ||
                                  targetUserId2 ==
                                      FirebaseAuth.instance.currentUser!.uid
                              ? FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('donors')
                                      .doc(groupIds[0])
                                      .get(),
                                  builder: (context, userData) {
                                    if (userData.hasError ||
                                        !userData.hasData ||
                                        !userData.data!.exists) {
                                      return const SizedBox();
                                    }
                                    final targetUser = userData.data;
                                    if (targetUser == null) {
                                      return const SizedBox();
                                    }
                                    return  
                                    
                                     Card(
                                      shadowColor: Colors.black,
                                      color: Colors.white,
                                      elevation: 13,
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: ListTile(                                               
                                          onTap: () {
                                            Get.to(() => ChatScreen(
                                                  fcmToken:
                                                      targetUser['fcmToken'],
                                                  name: targetUser['username'],
                                                  image: targetUser['image'],
                                                  uid: targetUser['donorId'],
                                                  groupId: FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                ));
                                          },
                                          contentPadding: EdgeInsets.zero,
                                          leading: CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                targetUser['image']),
                                          ),
                                          title: Text(
                                            targetUser['username'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          subtitle: Text(
      //  encrypter?.decrypt64(chatData['lastMessage'], iv: iv).toString()??'';

                                            chatData['lastMessage'],
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          trailing: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: Text(
                                              
                                              chatData['timeStamp'],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : const SizedBox();
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
