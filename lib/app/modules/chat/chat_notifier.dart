import 'package:academic/app/modules/chat/chat_state.dart';
import 'package:academic/app/modules/group_chat/group_chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/repository.dart';
import '../profile/profile_notifier.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState());

  TextEditingController sentMsgController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  // Method to send a message
  Future<void> _sendMessage(BuildContext context, WidgetRef ref) async {
    if (sentMsgController.text.isEmpty) return;

    // Reference to Firestore
    print("groupIdProvider...${ref.read(groupIdProvider.notifier).state}");
    /*  final messageCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(ref
            .read(groupIdProvider.notifier)
            .state) // Specify the chatId for this group chat
        .collection('messages');
    if (ref.read(profileProvider).name.isEmpty &&
        ref.read(profileProvider).profileImageUrl.isEmpty) {
      ref.read(profileProvider.notifier).fetchAndDisplayUserDetails();
    }
   // Sending the message to Firestore
    await messageCollection.add({
      'senderId': state.userUid,
      'message': sentMsgController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'userName': ProviderScope.containerOf(context, listen: false)
          .read(profileProvider)
          .name,
      "userprofilePic": ProviderScope.containerOf(context, listen: false)
          .read(profileProvider)
          .profileImageUrl
    });*/
    await FirebaseFirestore.instance.collection('groups')
        .doc(ref
        .read(groupIdProvider.notifier)
        .state)
        .collection('messages')
        .add({
      'senderId': SignInRepository.getUserId(),
      'message': sentMsgController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'userName': ProviderScope.containerOf(context, listen: false)
          .read(profileProvider)
          .name,
      "userprofilePic": ProviderScope.containerOf(context, listen: false)
          .read(profileProvider)
          .profileImageUrl
    });
    // Clear the input field
    sentMsgController.clear();
  }

  sendMsg(BuildContext context, WidgetRef ref) {
    if (formKey.currentState?.validate() ?? false) {
      if (sentMsgController.text.isNotEmpty) {
        _sendMessage(context, ref);
      }
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>(
  (ref) => ChatNotifier(),
);
