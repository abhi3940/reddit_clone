//loggedOut
//loggedIn

import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
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
  },
);