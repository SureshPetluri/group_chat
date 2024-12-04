import 'package:academic/app/modules/profile/profile_notifier.dart';
import 'package:academic/app/widgets/app_button.dart';
import 'package:academic/app/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/repository.dart';
import '../../utils/theme/color_theme.dart';
import '../profile/profile_screen.dart';
import 'user_management_notifier.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(userManagementProvider);
    final homeNotifier = ref.watch(userManagementProvider.notifier);
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

                            return SignInRepository.getUserId() != user.userId
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
                                                  print(
                                                      "selectedUsers.ghghghg....${homeNotifier.selectedUsers}");
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
                                      trailing: user.isVerified
                                          ? Icon(Icons.check_circle)
                                          : null,
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
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    onPressed: () async {
                      homeNotifier.onDeselectAllChanged(false);
                    },
                    title: "Reject",
                    titleColor: Colors.black,
                  ),
                  AppButton(
                    onPressed: () async {
                      homeNotifier.createGroup(context);
                    },
                    titleColor: Colors.black,
                    child: homeState.isGroupCreate
                        ? const CircularProgressIndicator()
                        : const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0),
                            child: Text(
                              "Approve",
                              style: TextStyle(color: blackColor, fontSize: 18),
                            ),
                          ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
