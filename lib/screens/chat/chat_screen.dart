import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import '../../controllers/data_controller.dart';
import '../../controllers/notification.dart';


class ChatScreen extends StatefulWidget {
  final String? image, name, groupId, fcmToken, uid;
  const ChatScreen(
      {super.key,
      this.image,
      this.name,
      this.groupId,
      this.fcmToken,
      this.uid
      });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isSendingMessage = false;
  String myUid = '';
  var screenheight;

  var screenwidth;

  //

 

  DataController dataController = Get.put(DataController());
  // CallController callController = Get.put(CallController());
  TextEditingController messageController = TextEditingController();
  FocusNode inputNode = FocusNode();
  String replyText = '';
  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
  }

  @override
  void initState() {
    super.initState();

    dataController = Get.find<DataController>();
    myUid = FirebaseAuth.instance.currentUser!.uid;
  }

  // void makeCall(BuildContext context) {
  //   callController.makeCall(
  //     context,
  //     widget.name.toString(),
  //     widget.uid.toString(),
  //     widget.image.toString(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;

    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            widget.image!.isEmpty
                ? const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.image!),
                  ),
            const SizedBox(
              width: 5,
            ),
            Column(
              children: [
                Text(
                  widget.name.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          //   width: 180,
          //   height: 25,
          //   decoration: ShapeDecoration(
          //     shape: RoundedRectangleBorder(
          //       side: const BorderSide(width: 1, color: Color(0xFFD3D3D3)),
          //       borderRadius: BorderRadius.circular(6),
          //     ),
          //   ),
          //   child: const Text(
          //     'Your chat is end-to-end encrypted',
          //     style: TextStyle(
          //       color: Color(0xFF535353),
          //       fontSize: 10,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          Expanded(
              child: Obx(() => dataController.isMessageSending.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      builder: (ctx, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        List<DocumentSnapshot> data =
                            snapshot.data!.docs.reversed.toList();

                        return ListView.builder(
                          reverse: true,
                          itemBuilder: (ctx, index) {
                            String messageUserId = data[index].get('uid');
                            String messageType = data[index].get('type');

                            Widget messageWidget = Container();

                            if (messageUserId == myUid) {
                              switch (messageType) {
                                case 'iSentText':
                                  messageWidget = textMessageISent(data[index]);
                                  break;

                                case 'iSentImage':
                                  messageWidget = imageSent(data[index]);
                                  break;
                                case 'iSentReply':
                                  messageWidget =
                                      sentReplyTextToText(data[index]);
                              }
                            } else {
                              switch (messageType) {
                                case 'iSentText':
                                  messageWidget =
                                      textMessageIReceived(data[index]);
                                  break;

                                case 'iSentImage':
                                  messageWidget = imageReceived(data[index]);
                                  break;
                                case 'iSentReply':
                                  messageWidget =
                                      receivedReplyTextToText(data[index]);
                              }
                            }

                            return messageWidget;
                          },
                          itemCount: data.length,
                        );
                      },
                      stream: dataController.getMessage(
                          widget.groupId, widget.uid)))),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MessageBar(
                        onTextChanged: (p0) {
                          messageController.text = p0;
                        },
                        sendButtonColor: Colors.green,
                        onSend: (_) async {
                          if (messageController.text.isEmpty) {
                            return;
                          }
                          String message = messageController.text;

                          messageController.clear();

                          Map<String, dynamic> data = {
                            'type': 'iSentText',
                            'message': message,
                            'timeStamp': DateTime.now(),
                            'uid': myUid
                          };

                          if (replyText.length > 0) {
                            data['reply'] = replyText;
                            data['type'] = 'iSentReply';
                            replyText = '';
                          }
                          DocumentSnapshot<Map<String, dynamic>> document =
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .get();
                          final userData = document.data()!;
                          String userName = userData['username'];
                          String userImage = userData['image'];
                          String fcmToken = userData['fcmToken'];

                          dataController.sendMessageToFirebase(
                              data: data,
                              userId: widget.groupId.toString(),
                              otherUserId: widget.uid.toString(),
                              lastMessage: message,
                              name: userName,
                              image: userImage,
                              fcmToken: fcmToken);

                          dataController.createNotification(
                            userId: widget.uid.toString(),
                            message: message,
                          );

                          LocalNotificationService.sendNotification(
                              title: 'New message from $userName',
                              message: message,
                              token: widget.fcmToken);
                        },
                        messageBarColor: Colors.grey.shade200,
                        actions: [
                          InkWell(
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 24,
                            ),
                            onTap: () {
                              openMediaDialog();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            child: InkWell(
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.green,
                                size: 24,
                              ),
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.camera);
                                if (image != null) {
                                  // Navigator.pop(context);

                                  dataController.isMessageSending(true);

                                  String imageUrl = await dataController
                                      .uploadImageToFirebase(File(image.path));

                                  Map<String, dynamic> data = {
                                    'type': 'iSentImage',
                                    'message': imageUrl,
                                    'timeStamp': DateTime.now(),
                                    'uid': myUid
                                  };
                                  DocumentSnapshot<Map<String, dynamic>>
                                      document = await FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .get();
                                  final userData = document.data()!;
                                  String userName = userData['username'];
                                  String userImage = userData['image'];
                                  String fcmToken = userData['fcmToken'];
                                  dataController.sendMessageToFirebase(
                                      data: data,
                                      userId: widget.groupId.toString(),
                                      otherUserId: widget.uid.toString(),
                                      lastMessage: 'Image',
                                      name: userName,
                                      image: userImage,
                                      fcmToken: fcmToken);

                                  dataController.createNotification(
                                    userId: widget.uid.toString(),
                                    message: 'sent you an image',
                                  );

                                  LocalNotificationService.sendNotification(
                                      title: 'New message from $userName',
                                      message: '$userName sent you an image',
                                      token: widget.fcmToken);
                                }
                              },
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
        ],
      ),
    );
  }

  //
  //
  String formatMessageTimestamp(DateTime timestamp) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Duration difference = today.difference(timestamp);

    if (difference.inDays == 0) {
      return formatTime(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday ${formatTime(timestamp)}';
    } else {
      return DateFormat('MMM d, yyyy hh:mm a').format(timestamp);
    }
  }

  String formatTime(DateTime timestamp) {
    return DateFormat('hh:mm a').format(timestamp);
  }

  //
//
  textMessageIReceived(DocumentSnapshot doc) {
    String message = '';
    try {
      message = doc.get('message');
    } catch (e) {
      message = '';
    }
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Dismissible(
        confirmDismiss: (a) async {
          replyText = message;
          await Future.delayed(const Duration(seconds: 1));
          openKeyboard();
          return false;
        },
        key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: widget.image!.isEmpty
                      ? const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(widget.image!),
                        ),
                ),
                BubbleSpecialOne(
                    text: message,
                    color: Colors.grey.shade300,
                    textStyle: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 62, top: 5),
                  child: Text(
                    DateFormat.MMMd().format(doc.get('timeStamp').toDate()),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    // formatMessageTimestamp
                    DateFormat('hh:mm a').format(doc.get('timeStamp').toDate()),
                    // DateFormat.Hm().format(doc.get('timeStamp').toDate()),
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  textMessageISent(DocumentSnapshot doc) {
    String message = doc.get('message');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BubbleSpecialOne(
            text: message,
            color: Colors.red,
            textStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFFF6FAFC),
                fontWeight: FontWeight.w400)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                DateFormat.MMMd().format(doc.get('timeStamp').toDate()),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 20),
              child: Text(
                DateFormat('hh:mm a').format(doc.get('timeStamp').toDate()),

                // DateFormat.Hm().format(doc.get('timeStamp').toDate()),
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ],
    );
  }

  imageSent(DocumentSnapshot doc) {
    String message = '';

    try {
      message = doc.get('message');
    } catch (e) {
      message = '';
    }

    return Container(
      margin: const EdgeInsets.only(right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: screenwidth * 0.42,
                height: screenheight * 0.18,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(18),
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18)),
                    image: DecorationImage(
                        image: NetworkImage(message), fit: BoxFit.fill)),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  DateFormat.MMMd().format(doc.get('timeStamp').toDate()),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  DateFormat('hh:mm a').format(doc.get('timeStamp').toDate()),

                  // DateFormat.Hm().format(doc.get('timeStamp').toDate()),
                  style: const TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  imageReceived(DocumentSnapshot doc) {
    String message = '';
    try {
      message = doc.get('message');
    } catch (e) {
      message = '';
    }
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: widget.image!.isEmpty
                    ? const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(widget.image!),
                      ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                width: screenwidth * 0.42,
                height: screenheight * 0.18,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(18),
                        topLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18)),
                    image: DecorationImage(
                        image: NetworkImage(message), fit: BoxFit.fill)),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 62, top: 5),
                child: Text(
                  DateFormat.MMMd().format(doc.get('timeStamp').toDate()),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  DateFormat('hh:mm a').format(doc.get('timeStamp').toDate()),

                  // DateFormat.Hm().format(doc.get('timeStamp').toDate()),
                  style: const TextStyle(color: Colors.black),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  sentReplyTextToText(DocumentSnapshot doc) {
    String message = '';
    String reply = '';
    try {
      message = doc.get('message');
    } catch (e) {
      message = '';
    }

    try {
      reply = doc.get('reply');
    } catch (e) {
      reply = '';
    }

    return Container(
      margin: const EdgeInsets.only(right: 20, top: 5, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 66, top: 5),
                child: Text(
                  "You replied to ${widget.name}",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: screenheight * 0.006,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BubbleSpecialOne(
                  text: reply,
                  color: Colors.green,
                  textStyle: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w400)),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Container(
                  width: 1,
                  height: 50,
                  color: const Color(0xff918F8F),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenheight * 0.003,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BubbleSpecialOne(
                  text: message,
                  color: Colors.red,
                  textStyle: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w400)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  DateFormat.MMMd().format(doc.get('timeStamp').toDate()),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  DateFormat('hh:mm a').format(doc.get('timeStamp').toDate()),

                  // DateFormat.Hm().format(doc.get('timeStamp').toDate()),
                  style: const TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  receivedReplyTextToText(DocumentSnapshot doc) {
    String message = '';
    String reply = '';
    try {
      message = doc.get('message');
    } catch (e) {
      message = '';
    }

    try {
      reply = doc.get('reply');
    } catch (e) {
      reply = '';
    }

    return InkWell
    (
      onTap: () {
        
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 66, top: 5),
                  child: Text(
                    "Replied to you ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: screenheight * 0.006,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 44, right: 10),
                  child: Container(
                    width: 1,
                    height: 50,
                    color: const Color(0xff918F8F),
                  ),
                ),
                BubbleSpecialOne(
                    text: reply,
                    color: Colors.red,
                    textStyle: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            SizedBox(
              height: screenheight * 0.003,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: widget.image!.isEmpty
                      ? const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(widget.image!),
                        ),
                ),
                BubbleSpecialOne(
                    text: message,
                    color: Colors.grey.shade300,
                    textStyle: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 62, top: 5),
                  child: Text(
                    DateFormat.MMMd().format(doc.get('timeStamp').toDate()),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    DateFormat('hh:mm a').format(doc.get('timeStamp').toDate()),
      
                    // DateFormat.Hm().format(doc.get('timeStamp').toDate()),
                    style: const TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void openMediaDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    Get.back();

                    dataController.isMessageSending(true);

                    String imageUrl = await dataController
                        .uploadImageToFirebase(File(image.path));

                    Map<String, dynamic> data = {
                      'type': 'iSentImage',
                      'message': imageUrl,
                      'timeStamp': DateTime.now(),
                      'uid': myUid
                    };
                    DocumentSnapshot<Map<String, dynamic>> document =
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();
                    final userData = document.data()!;
                    String userName = userData['username'];
                    String userImage = userData['image'];
                    String fcmToken = userData['fcmToken'];
                    dataController.sendMessageToFirebase(
                        data: data,
                        userId: widget.groupId.toString(),
                        otherUserId: widget.uid.toString(),
                        lastMessage: 'Image',
                        name: userName,
                        image: userImage,
                        fcmToken: fcmToken);

                    dataController.createNotification(
                      userId: widget.uid.toString(),
                      message: 'sent you an image',
                    );

                    LocalNotificationService.sendNotification(
                        title: 'New message from $userName',
                        message: '$userName sent you an image',
                        token: widget.fcmToken);
                  }
                },
                child: const Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      Get.back();

                      dataController.isMessageSending(true);

                      String imageUrl = await dataController
                          .uploadImageToFirebase(File(image.path));

                      Map<String, dynamic> data = {
                        'type': 'iSentImage',
                        'message': imageUrl,
                        'timeStamp': DateTime.now(),
                        'uid': myUid
                      };
                      DocumentSnapshot<Map<String, dynamic>> document =
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get();
                      final userData = document.data()!;
                      String userName = userData['username'];
                      String userImage = userData['image'];
                      String fcmToken = userData['fcmToken'];
                      dataController.sendMessageToFirebase(
                          data: data,
                          userId: widget.groupId.toString(),
                          otherUserId: widget.uid.toString(),
                          lastMessage: 'Image',
                          name: userName,
                          image: userImage,
                          fcmToken: fcmToken);

                      dataController.createNotification(
                        userId: widget.uid.toString(),
                        message: 'sent you an image',
                      );

                      LocalNotificationService.sendNotification(
                          title: 'New message from $userName',
                          message: '$userName sent you an image',
                          token: widget.fcmToken);
                    }
                  },
                  child: const Icon(Icons.image)),
            ],
          ),
        );
      },
    );
  }
}
