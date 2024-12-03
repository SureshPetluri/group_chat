import 'dart:convert';

import 'package:academic/app/utils/theme/color_theme.dart';
import 'package:academic/app/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../group_chat/group_chat_state.dart';
import 'edit_group_notifier.dart';

/*
class EditGroupScreen extends ConsumerWidget {
  const EditGroupScreen({
    super.key,required this.groupData
  });
  final  GroupModel groupData;
  @override
  _EditGroupScreenState createState() => _EditGroupScreenState();
}
*/

/*class _EditGroupScreenState extends ConsumerState<EditGroupScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    ref.read(editGroupProvider.notifier).getGroupDetails(ref);
    super.didChangeDependencies();
  }*/
class EditGroupScreen extends ConsumerWidget {
  const EditGroupScreen({super.key, required this.groupData});

  final GroupModel groupData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editGroup = ref.watch(editGroupProvider);
    final editGroupNotifier = ref.read(editGroupProvider.notifier);
    /* final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final String groupId = args?["groupId"] ?? "";*/
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              editGroupNotifier.state = editGroupNotifier.state
                  .copyWith(imageBase64: "", imageName: "");
              Navigator.pop(context, "update");
            }
          },
        ),
        title: Text(
          ref.watch(groupNameProvider.notifier).state,
          style: const TextStyle(color: whiteColor),
        ),
      ),
      body: Column(
        children: [
          Card(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: (ref.watch(groupImageUrlProvider.notifier).state.isEmpty &&
                    editGroup.imageBase64.isEmpty)
                ? const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.camera_alt))
                : ref.watch(groupImageUrlProvider.notifier).state.isEmpty
                    ? Image.memory(
                        base64Decode(editGroup.imageBase64),
                        height: 100,
                        width: 100,
                      )
                    : networkImage(
                        imageUrl:
                            ref.watch(groupImageUrlProvider.notifier).state,
                        height: 100,
                        width: 100,
                      ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(ref.watch(groupNameProvider.notifier).state),
              Text(" ${groupData.members.length}"),
              const Text(" numbers"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: groupData.members.length,
                itemBuilder: (context, index) {
                  var member = groupData.members[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: member.profileImageUrl.isEmpty
                          ? const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.camera_alt))
                          : Card(
                              shape: CircleBorder(),
                              clipBehavior: Clip.antiAlias,
                              child: networkImage(
                                imageUrl: member.profileImageUrl,
                                height: 50,
                              ),
                            ),
                      title: Text(member.profileName),
                      trailing: member.isGroupAdmin
                          ? const Text("Group Admin")
                          : const Text(""),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
