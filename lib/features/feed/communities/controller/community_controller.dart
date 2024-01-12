import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/contorller/auth_controller.dart';
import 'package:reddit_clone/features/communities/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getUserCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunitybyName(name);
});

final searchCommunitiesProvider = StreamProvider.family((ref, String query) {
  return ref
      .watch(communityControllerProvider.notifier)
      .searchCommunities(query);
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(CommunityRepositoryProvider);
  final storeageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(
      communityRepository: communityRepository,
      storageRepository: storeageRepository,
      ref: ref);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  CommunityController({
    required CommunityRepository communityRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _communityRepository = communityRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);

    final res = await _communityRepository.createCommuniy(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created sucesssfully!');
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(Community community, BuildContext context) async {
    final user = _ref.read(userProvider);
    Either<Failure, void> res;
    if (community.members.contains(user?.uid)) {
      res =
          await _communityRepository.leaveCommunity(community.name, user!.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.name, user!.uid);
    }
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (community.members.contains(user.uid)) {
        showSnackBar(context, 'You left the community!');
      } else {
        showSnackBar(context, 'You joined the community!');
      }
    });
  }

  Stream<Community> getCommunitybyName(String name) {
    return _communityRepository.getCommunitybyName(name);
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }

  void editCommunity(
      {required Community community,
      required File? profileFile,
      required File? bannerFile,
      required BuildContext context}) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/avatars',
        id: community.id,
        file: profileFile,
      );
      res.fold((l) => showSnackBar(context, l.message), (r) {
        community = community.copyWith(avatar: r);
      });
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.name,
        file: profileFile,
      );
      res.fold((l) => showSnackBar(context, l.message), (r) {
        community = community.copyWith(banner: r);
      });
    }
    final res = await _communityRepository.editCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community edited sucesssfully!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Community>> searchCommunities(String query) {
    return _communityRepository.searchCommunities(query);
  }

  void addMods(
      String communityName, List<String> uids, BuildContext context) async {
    final res = await _communityRepository.addMods(communityName, uids);
    res.fold((l) => showSnackBar(context, l.message),
        (r) => Routemaster.of(context).pop());
  }
}
