import 'package:academic/app/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/theme/color_theme.dart';
import '../../widgets/network_image.dart';
import 'profile_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileData = ref.watch(profileProvider);
    final profile = ref.watch(profileProvider.notifier);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: appBarColor,
        foregroundColor: appBarColor,
        surfaceTintColor: appBarColor,
        title: const Text(
          "Profile",
          style: TextStyle(color: whiteColor),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 20.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        margin: const EdgeInsets.only(top: 40),
                        padding: const EdgeInsets.only(top: 40, bottom: 15),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              profileData.name,
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${profileData.mobile}/${profileData.email}",
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Card(
                            shape: CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: profileData.profileImageUrl.isNotEmpty
                                ? networkImage(
                                    imageUrl: profileData.profileImageUrl,
                                    height: 100,
                                  )
                                : const CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.pink,
                                    child: Icon(Icons.person,
                                        size: 40, color: Colors.white),
                                  )),
                       /* Positioned(
                          right: 0.0,
                          bottom: 10.0,
                          child: InkWell(
                            onTap: () {
                              // profileNotifier.profileImageUpdate(context);
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.edit,
                                  size: 12, color: Colors.pink),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ],
                ),
              ),
              ExpansionTile(
                  controller: profile.expansionAddressController,
                  title: const Text(
                    "Add Address",
                    style: TextStyle(color: Colors.black),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: profile.formKey,
                        child: Column(children: [
                          TextFormField(
                            controller: profile.streetController,
                            decoration: InputDecoration(
                              labelText: 'Street Address',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the street address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: profile.cityController,
                            decoration: InputDecoration(
                              labelText: 'City',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the city';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: profile.stateController,
                            decoration: InputDecoration(
                              labelText: 'State',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the state';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: profile.postalCodeController,
                            decoration: InputDecoration(
                              labelText: 'Zip Code',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the zip code';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppButton(
                                height: 30,
                                borderRadius: 5,
                                onPressed: () {
                                  profile.expansionAddressController.collapse();
                                },
                                title: "Cancel",
                                titleFontSize: 14,
                                titleColor: Colors.black,
                              ),
                              AppButton(
                                disableBtn: profileData.state.isNotEmpty,
                                height: 30,
                                borderRadius: 5,
                                onPressed: () async {
                                  // if (_formKey.currentState?.validate() ?? false) {
                                  // Process the data if the form is valid
                                  await profile.updateAddress(context);
                                },
                                title: "Submit",
                                titleFontSize: 14,
                                titleColor: Colors.black,
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
              ExpansionTile(
                  controller: profile.expansionLogoutController,
                  title: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.black),
                  ),
                  children: [
                    const Text("Are you Sure you want to logout"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppButton(
                          height: 30,
                          borderRadius: 5,
                          onPressed: () {
                            profile.expansionLogoutController.collapse();
                          },
                          title: "Cancel",
                          titleFontSize: 14,
                          titleColor: Colors.black,
                        ),
                        AppButton(
                          height: 30,
                          borderRadius: 5,
                          onPressed: () async {
                            await profile.logOut(context);
                          },
                          title: "Log Out",
                          titleFontSize: 14,
                          titleColor: Colors.black,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
