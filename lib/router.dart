//loggedOut
//loggedIn

import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/communities/screens/community_screen.dart';
import 'package:reddit_clone/features/communities/screens/create_community_screen.dart';
import 'package:reddit_clone/features/communities/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/communities/screens/mod_tools_scren.dart';
import 'package:reddit_clone/features/home/screens/home_screen.dart';
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
    '/mod-tools/:name': (RouteData) => MaterialPage<void>(
            child: ModToolsScreen(
          name: RouteData.pathParameters['name']!,
        )),
    '/edit-community/:name': (RouteData) => MaterialPage(
          child: EditCommunityScreen(
            name: RouteData.pathParameters['name']!,
          ),
        ),
    
  },
);
