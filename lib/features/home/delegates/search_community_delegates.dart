import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/features/communities/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDeligates extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDeligates(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunitiesProvider(query)).when(
          data: (communites) => ListView.builder(
              itemCount: communites.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(communites[index].avatar),
                  ),
                  title: Text('r/${communites[index].name}'),
                  onTap: () {
                    navigateToCommunity(context, communites[index].name);
                  },
                );
              }),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('r/$communityName');
  }
}
