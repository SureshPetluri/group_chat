import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/theme/color_theme.dart';
import '../../widgets/network_image.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_notifier.dart';
import '../profile/profile_screen.dart';
import 'group_chat_notifier.dart';
import 'group_chat_state.dart';

class GroupScreen extends ConsumerWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var group = ref.watch(groupChatProvider);
    var groupNotifier = ref.read(groupChatProvider.notifier);
    final profileImage = ref.read(profileProvider);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        automaticallyImplyLeading: false,
        title: const Text(
          "Group",
          style: TextStyle(color: whiteColor),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: profileImage.profileImageUrl.isNotEmpty
                      ? networkImage(
                          imageUrl: profileImage.profileImageUrl,
                          height: 100,
                        )
                      : const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.pink,
                          child:
                              Icon(Icons.person, size: 40, color: Colors.white),
                        )),
            ),
          ),
        ],
      ),
      body: group.groupMembers.isNotEmpty
          ? Builder(builder: (context) {
              return ListView.builder(
                  itemCount: group.groupMembers.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var groupData = group.groupMembers[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 0.0,
                        minLeadingWidth: 0.0,
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: Stack(
                          alignment: Alignment.center,
                          children: [
                            InkWell(
                              radius: 0.4,
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Card(
                                    shape: const CircleBorder(),
                                    clipBehavior: Clip.antiAlias,
                                    child: groupData.groupImageUrl.isNotEmpty
                                        ? networkImage(
                                            imageUrl: groupData.groupImageUrl,
                                            height: 100,
                                          )
                                        : const Icon(Icons.person,
                                            size: 40, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                        title: Text(groupData.groupName),
                        onTap: () async {
                          ref.watch(groupNameProvider.notifier).state =
                              groupData.groupName;
                          ref.watch(groupIdProvider.notifier).state =
                              groupData.groupId;
                          print(
                              "groupIdProvider...${ref.watch(groupIdProvider.notifier).state}");
                          ref.watch(groupImageUrlProvider.notifier).state =
                              groupData.groupImageUrl;
                          var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  ChatScreen(groupData: groupData,),
                              ));
                          if (result == 'update') {
                            groupNotifier.fetchGroups();
                            print(
                                "groupChat group details ${groupData.groupId}");
                          }
                        },
                      ),
                    );
                  });
            })
          : const Center(
              child: Text(
              "You don't Create Community chat to connect",
              style: TextStyle(color: blackColor, fontSize: 16),
            )),
    );
  }
}
