import 'dart:convert';

import 'package:academic/app/modules/profile/profile_notifier.dart';
import 'package:academic/app/utils/form_utils.dart';
import 'package:academic/app/widgets/app_button.dart';
import 'package:academic/app/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/repository.dart';
import '../../utils/theme/color_theme.dart';
import '../group_chat/group_chat_state.dart';
import '../profile/profile_screen.dart';
import 'home_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeStateProvider);
    final homeNotifier = ref.watch(homeStateProvider.notifier);
    final profileImage = ref.read(profileProvider);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        leadingWidth: homeState.selectedItems.any((item) => item) ? 135 : 0.0,
        leading: Visibility(
          visible: homeState.selectedItems.any((item) => item),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Select All",
                  style: TextStyle(color: whiteColor),
                ),
                Checkbox(
                  value: homeState.selectAll,
                  onChanged: homeNotifier.onSelectAllChanged,
                ),
              ],
            ),
          ),
        ),
        // centerTitle: false,
        title: const Text(
          "All Users",
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
              padding: EdgeInsets.all(8.0),
              child: Card(
                  shape: CircleBorder(),
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
      body: homeState.users.length > 1
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeState.users.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            var user = homeState.users[index];
                            if ((SignInRepository.getUserId() == user.userId) &&
                                (homeState.currentUserIndex == -1)) {
                              homeNotifier.currentUser(index);
                            }
                            return ((SignInRepository.getUserId() !=
                                        user.userId) &&
                                    (user.isVerified == true))
                                ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      horizontalTitleGap: 0.0,
                                      minLeadingWidth: 100.0,
                                      titleAlignment:
                                          ListTileTitleAlignment.center,

                                      leading: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          InkWell(
                                            radius: 0.4,
                                            onTap: () {
                                              homeNotifier.onItemSelected(
                                                  true, index);
                                              homeNotifier.selectedUsers.add({
                                                "userId": user.userId,
                                                "docId": user.docId,
                                                "profileName": user.name,
                                                "isGroupAdmin": SignInRepository
                                                        .getUserId() ==
                                                    user.userId,
                                                "profileImage":
                                                    user.profileImageUrl
                                              });
                                              print(
                                                  "selectedUsers.....${homeNotifier.selectedUsers}");
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Card(
                                                semanticContainer: false,
                                                // elevation: 5,
                                                margin: EdgeInsets.zero,
                                                shape: const CircleBorder(),
                                                clipBehavior: Clip.antiAlias,
                                                child: (user.profileImageUrl
                                                        .isNotEmpty)
                                                    ? networkImage(
                                                        imageUrl: user
                                                            .profileImageUrl,
                                                        fit: BoxFit.contain,
                                                        // You can use BoxFit.cover to ensure the image fills the entire circle
                                                        width: 80,
                                                        // You can adjust width and height here
                                                        height: 80,
                                                      )
                                                    : const Icon(Icons.person,
                                                        size: 80,
                                                        color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: homeState
                                                    .selectedItems[index] ==
                                                true,
                                            child: Positioned.fill(
                                              child: InkWell(
                                                radius: 0.4,
                                                onTap: () {
                                                  homeNotifier.onItemSelected(
                                                      false, index);
                                                  homeNotifier.selectedUsers
                                                      .removeAt(index);
                                                  print(
                                                      "selectedUsers.....${homeNotifier.selectedUsers}");
                                                },
                                                child: const Icon(
                                                    Icons.check_circle),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      title: SignInRepository.getUserId() ==
                                              user.userId
                                          ? const Text("Self")
                                          : Text(user.name),
                                      // onTap: () {
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (context) => const ChatScreen()));
                                      // },
                                      /* trailing: Checkbox(
                            value: homeState.selectedItems[index],
                            onChanged: (value) {
                              homeNotifier.onItemSelected(value, index);
                            },
                          ),*/
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }),
                      /*  if (homeState.selectedItems.any((item) => item))
                  Positioned(
                    bottom: 10.0,
                    left: 30.0,
                    right: 30.0,
                    child: AppButton(
                      onPressed: () {
                        homeNotifier.onDeselectAllChanged(false);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GroupScreen()));
                        SnackNotification.showCustomSnackBar(
                            "Group Created with Selected Users");
                        // _showAlertDialog(context);
                      },
                      title: "Create Group",
                      titleColor: Colors.black,
                    ),
                  )*/
                    ],
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                homeState.isSubmitting
                    ? "Loading..."
                    : "No Users Find In This Community.",
                style: const TextStyle(color: blackColor, fontSize: 16),
              )),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (homeState.selectedItems.any((item) => item))
          ? Form(
              key: homeNotifier.formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: ref
                              .watch(groupImageUrlProvider.notifier)
                              .state
                              .isEmpty
                          ? () {
                              homeNotifier.profileImageUpdate(
                                  context,
                                  ref.watch(groupIdProvider.notifier).state,
                                  ref);
                            }
                          : null,
                      child: Card(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: (ref
                                    .watch(groupImageUrlProvider.notifier)
                                    .state
                                    .isEmpty &&
                                homeState.imageBase64.isEmpty)
                            ? const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.camera_alt))
                            : ref
                                    .watch(groupImageUrlProvider.notifier)
                                    .state
                                    .isEmpty
                                ? Image.memory(
                                    base64Decode(homeState.imageBase64),
                                    height: 100,
                                    width: 100,
                                  )
                                : networkImage(
                                    imageUrl: ref
                                        .watch(groupImageUrlProvider.notifier)
                                        .state,
                                    height: 100,
                                    width: 100,
                                  ),
                      ),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Group Name"),
                      controller: homeNotifier.groupNameController,
                      validator: (text) => FormValidations.notEmpty(text,
                          fieldName: "Group Name"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      onPressed: () async {
                        await homeNotifier.createGroup(
                          context,
                          ref,
                          ref.watch(groupIdProvider.notifier).state,
                        );
                      },
                      titleColor: Colors.black,
                      child: homeState.isGroupCreate
                          ? const CircularProgressIndicator()
                          : const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18.0),
                              child: Text(
                                "Create Group",
                                style:
                                    TextStyle(color: blackColor, fontSize: 18),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
