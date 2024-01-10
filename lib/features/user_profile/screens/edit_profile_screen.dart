import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/contorller/auth_controller.dart';

import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';

import 'package:reddit_clone/theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBanner() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        bannerFile = File(image.files.single.path!);
      });
    }
  }

  void selectProfile() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        profileFile = File(image.files.single.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editCommunity(
        profileFile: profileFile,
        bannerFile: bannerFile,
        context: context,
        name: nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(ThemeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) {
            return Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: const Text('Edit Profile'),
                centerTitle: false,
                actions: [
                  TextButton(onPressed: save, child: const Text('Save')),
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: selectBanner,
                                  child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      dashPattern: const [10, 4],
                                      strokeCap: StrokeCap.round,
                                      color: currentTheme
                                          .textTheme.bodyText1!.color!,
                                      radius: const Radius.circular(10),
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: bannerFile != null
                                            ? Image.file(bannerFile!)
                                            : user.banner.isEmpty ||
                                                    user.banner ==
                                                        Constants.bannerDefault
                                                ? const Center(
                                                    child:
                                                        Icon(Icons.add_a_photo))
                                                : Image.network(
                                                    user.banner,
                                                    fit: BoxFit.cover,
                                                  ),
                                      )),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                      onTap: selectProfile,
                                      child: profileFile != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  FileImage(profileFile!),
                                              radius: 32,
                                            )
                                          : CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(user.profilePic),
                                              radius: 32,
                                            )),
                                )
                              ],
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.blue)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                            ),
                          )
                        ],
                      ),
                    ),
            );
          },
          loading: () => const Loader(),
          error: (error, stack) => ErrorText(
            error: error.toString(),
          ),
        );
  }
}
