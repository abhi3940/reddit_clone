//loggedOut
//loggedIn

import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/communities/screens/add_mod_screen.dart';
import 'package:reddit_clone/features/communities/screens/community_screen.dart';
import 'package:reddit_clone/features/communities/screens/create_community_screen.dart';
import 'package:reddit_clone/features/communities/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/communities/screens/mod_tools_scren.dart';
import 'package:reddit_clone/features/home/screens/home_screen.dart';
import 'package:reddit_clone/features/posts/screens/add_post_type_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoutes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage<void>(child: LoginScreen()),
  },
);

final loggedInRoutes = RouteMap(
  routes: {
    '/': (_) => const MaterialPage<void>(child: HomeScreen()),
    '/create-community/': (_) =>
        const MaterialPage<void>(child: CreateCommunityScren()),
    '/r/:name': (route) => MaterialPage(
            child: CommunityScreen(
          name: route.pathParameters['name']!,
        )),
    '/mod-tools/:name': (route) => MaterialPage<void>(
            child: ModToolsScreen(
          name: route.pathParameters['name']!,
        )),
    '/edit-community/:name': (route) => MaterialPage(
          child: EditCommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/add-mods/:name': (route) => MaterialPage(
          child: AddModScreen(
            name: route.pathParameters['name']!,
          ),
        ),
    '/u/:uid': (route) => MaterialPage(
            child: UserProfileScreen(
          uid: route.pathParameters['uid']!,
        )),
      '/edit-profile/:uid': (route) => MaterialPage(
            child: EditProfileScreen(
          uid: route.pathParameters['uid']!,
        )),
        '/add-post/:type': (route) => MaterialPage(
            child: AddPostTypeScreen(
          type: route.pathParameters['type']!,
        )),
  },
);
