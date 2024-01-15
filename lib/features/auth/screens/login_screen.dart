import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/sign_in_button.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/contorller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInASGuest(WidgetRef ref, BuildContext context) {
    ref.read(authContollerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authContollerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.logoPath, height: 40),
        actions: [
          TextButton(
              onPressed: () => signInASGuest(ref, context),
              child: Text('Skip', style: TextStyle(color: Pallete.blueColor)))
        ],
      ),
      body: isLoading?const Loader():Column(children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(Constants.loginEmotePath, height: 400),
        ),
        const SizedBox(height: 30),
        const SignInButton(),
      ]),
    );
  }
}
