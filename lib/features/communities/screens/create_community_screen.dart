import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';

class CreateCommunityScren extends ConsumerStatefulWidget {
  const CreateCommunityScren({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScrenState();
}

class _CreateCommunityScrenState extends ConsumerState<CreateCommunityScren> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
          communityNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create new community'),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text('Community Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: communityNameController,
                  decoration: const InputDecoration(
                    hintText: 'r/Community_name',
                    filled: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(18),
                  ),
                  maxLength: 21,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: createCommunity,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Create Communithy',
                    style: TextStyle(fontSize: 17),
                  ),
                )
              ]),
            ),
    );
  }
}
