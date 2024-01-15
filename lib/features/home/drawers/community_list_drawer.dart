
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/features/auth/contorller/auth_controller.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityDrawer extends ConsumerWidget {
  const CommunityDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          isGuest?const SignInButton(isFromLogin: false,):
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add another community'),
            onTap: () => navigateToCreateCommunity(context),
          ),
          if(!isGuest)
          ref.watch(userCommunitiesProvider).when(
              data: (communities) => Expanded(
                      child: ListView.builder(
                        itemCount: communities.length,
                        itemBuilder: (BuildContext context, int index) {
                          final community = communities[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                            ),
                            title: Text('r/${community.name}'),
                            onTap: () {
                              navigateToCommunity(context, community);
                            },
                          );
                        },
                      ),
                    ),
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader())
        ],
      )),
    );
  }
}
