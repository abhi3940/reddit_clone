// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

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

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
        community: community,
        profileFile: profileFile,
        bannerFile: bannerFile,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return ref.watch(getCommunityByNameProvider('crybaby')).when(
          data: (community) {
            return Scaffold(
              backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
              appBar: AppBar(
                title: const Text('Edit Community'),
                centerTitle: false,
                actions: [
                  TextButton(
                      onPressed: () => save(community),
                      child: const Text('Save')),
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
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
                                    color: Pallete.darkModeAppTheme.textTheme
                                        .bodyText1!.color!,
                                    radius: const Radius.circular(10),
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: bannerFile != null
                                          ? Image.file(bannerFile!)
                                          : community.banner.isEmpty ||
                                                  community.banner ==
                                                      Constants.bannerDefault
                                              ? const Center(
                                                  child:
                                                      Icon(Icons.add_a_photo))
                                              : Image.network(
                                                  community.banner,
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
                                                NetworkImage(community.avatar),
                                            radius: 32,
                                          )),
                              )
                            ],
                          ),
                        )
                      ]),
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
