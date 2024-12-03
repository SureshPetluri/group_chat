import 'package:academic/app/modules/edit_group/edit_group_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/theme/color_theme.dart';
import '../../widgets/network_image.dart';
import '../group_chat/group_chat_state.dart';
import 'chat_notifier.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({
    super.key,required this.groupData
  });
 final  GroupModel groupData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final String groupId = args?["groupId"] ?? "";*/
    final groupChat = ref.read(chatProvider.notifier);
    final groupChatN = ref.watch(chatProvider);
    String groupImage = ref.read(groupImageUrlProvider.notifier).state;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        leadingWidth: 250,
        leading: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context, "update");
                }
              },
              icon: const Icon(
                Icons.arrow_back,
                color: whiteColor,
              ),
            ),
            InkWell(
              radius: 0.4,
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  EditGroupScreen(groupData:groupData),
                  ),
                );
                if (result == "update") {
                  groupChat.state = groupChat.state.copyWith(
                      groupImage:
                          ref.read(groupImageUrlProvider.notifier).state);
                  groupImage = groupChatN.groupImage;
                }
              },
              child: Card(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: groupImage.isNotEmpty
                      ? networkImage(
                          imageUrl: groupImage,
                          height: 80,
                        )
                      : const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.pink,
                          child:
                              Icon(Icons.person, size: 40, color: Colors.white),
                        )),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Text(
              ref.watch(groupNameProvider.notifier).state,
              style: const TextStyle(color: whiteColor, fontSize: 24),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
        child: Form(
          key: groupChat.formKey,
          child: Row(
            children: [
              Flexible(
                  child: TextFormField(
                controller: groupChat.sentMsgController,
                // validator: FormValidations.notEmpty,
              )),
              const SizedBox(
                width: 2.0,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  groupChat.sendMsg(context, ref);
                },
                icon: const Icon(
                  Icons.send,
                  size: 40,
                ),
                /*icon: Transform.rotate(
                      angle: 270,
                      child: Icon(
                        Icons.send,
                        size: 40,
                      )),*/
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 55.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(ref
                    .read(groupIdProvider.notifier)
                    .state) // Fetch messages from the group's specific document
                .collection('messages')
                .orderBy('timestamp', descending: false) // Order by timestamp
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final messages = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment:
                            (messages[index]['senderId'] ?? "") ==
                                    groupChatN.userUid
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                        children: [
                          Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: const Radius.circular(10.0),
                                      topLeft: const Radius.circular(10.0),
                                      bottomLeft: Radius.circular(
                                          (messages[index]['senderId'] ?? "") ==
                                                  groupChatN.userUid
                                              ? 0.0
                                              : 10.0),
                                      bottomRight: Radius.circular(
                                          (messages[index]['senderId'] ?? "") !=
                                                  groupChatN.userUid
                                              ? 0.0
                                              : 10.0)),
                                  border: Border.all()),
                              child: Text(messages[index]['message'] ?? "")),
                          const SizedBox(
                            height: 1.0,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if ((messages[index]['senderId'] ?? "") !=
                                  groupChatN.userUid) ...[
                                Text(messages[index]['userName'] ?? ""),
                                const SizedBox(
                                  width: 2.0,
                                ),
                              ],
                              (messages[index]['userprofilePic'] ?? "")
                                      .toString()
                                      .isEmpty
                                  ? const CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.grey,
                                    )
                                  : Card(
                                      shape: const CircleBorder(),
                                      clipBehavior: Clip.antiAlias,
                                      child: networkImage(
                                        imageUrl: messages[index]
                                                ['userprofilePic'] ??
                                            "",
                                        height: 20,
                                      ),
                                    ),
                              if ((messages[index]['senderId'] ?? "") ==
                                  groupChatN.userUid) ...[
                                Text(messages[index]['userName'] ?? ""),
                                const SizedBox(
                                  width: 2.0,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  // Method to send a message
  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    // Reference to Firestore
    final messageCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc('groupChatId') // Specify the chatId for this group chat
        .collection('messages');

    // Sending the message to Firestore
    await messageCollection.add({
      'senderId': _user.uid,
      'message': _controller.text,
      'timestamp': FieldValue.serverTimestamp(),
      'userName':"",
      "userprofilePic":""
    });

    // Clear the input field
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc('groupChatId') // Same group chat ID
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true, // To display latest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index];
                    return ListTile(
                      title: Text(messageData['message']),
                      subtitle: Text('Sent by: ${messageData['senderId']}'),
                      trailing: Text(messageData['timestamp']?.toDate()?.toString() ?? 'No Date'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
