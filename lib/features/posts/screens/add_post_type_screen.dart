import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';
import 'package:reddit_clone/features/posts/contoller/add_post_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final discriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    discriptionController.dispose();
    linkController.dispose();
  }

  void selectBanner() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        bannerFile = File(image.files.single.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        (bannerFile != null) &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: discriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImage = widget.type == 'image';
    final isText = widget.type == 'text';
    final isLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);
    final currentTheme = ref.watch(ThemeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(onPressed: sharePost, child: const Text('Share')),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter title here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    maxLength: 30,
                  ),
                  const SizedBox(height: 10),
                  if (isImage)
                    GestureDetector(
                      onTap: selectBanner,
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: currentTheme.textTheme.bodyText1!.color!,
                          radius: const Radius.circular(10),
                          child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: bannerFile != null
                                  ? Image.file(bannerFile!)
                                  : const Center(
                                      child: Icon(Icons.add_a_photo)))),
                    ),
                  if (isText)
                    TextField(
                      controller: discriptionController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter description here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      maxLines: 5,
                    ),
                  if (isLink)
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter link here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Select Community'),
                  ),
                  ref.watch(userCommunitiesProvider).when(
                      data: (data) {
                        communities = data;

                        if (data.isEmpty) {
                          return const SizedBox();
                        }

                        return DropdownButton(
                          value: selectedCommunity ?? data[0],
                          items: data
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedCommunity = val;
                            });
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader()),
                ],
              ),
            ),
    );
  }
}
