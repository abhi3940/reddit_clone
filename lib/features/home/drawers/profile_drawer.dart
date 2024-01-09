import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/contorller/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});
  
  void logOut(WidgetRef ref) {
    ref.read(authContollerProvider.notifier).logOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(child: Column(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(user.profilePic),
          radius: 70,
        ),
        const SizedBox(height: 10,),
        Text('u/${user.name}',style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w500),),
        const SizedBox(height: 10,),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('My profile'),
          onTap: () {
          },
        ),
        
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log Out'),
          onTap: () {
            logOut(ref);
          },
        ),
        Switch.adaptive(value: true, onChanged: (val){}, )
      ]),)
    );
  }
}