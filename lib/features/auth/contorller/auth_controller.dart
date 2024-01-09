// Importing necessary packages and modules.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repositories/auth_repository.dart';
import 'package:reddit_clone/models/user_model.dart';

// Provider for UserModel. It uses StateProvider to manage the state of the user.
final userProvider = StateProvider<UserModel?>((ref) => null);

// Provider for AuthController. It uses StateNotifierProvider to manage the state of the authentication.
final authContollerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authRepository: ref.watch(authRepositoryProvider), ref: ref));

// Provider for auth state changes. It uses StreamProvider to listen to the auth state changes.
final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authContollerProvider.notifier);
  return authController.authStateChanges;
});

// Provider for getting user data. It uses StreamProvider.family to listen to the user data changes for a specific user id.
final getUserDataProvider = StreamProvider.family((ref, String uid)  {
  final authController = ref.watch(authContollerProvider.notifier);
  return authController.getUserData(uid);
});

// AuthController class. It extends StateNotifier to manage the state of the authentication.
class AuthController extends StateNotifier<bool> {
  // Private instance of AuthRepository.
  final AuthRepository _authRepository;
  // Private instance of Ref.
  final Ref _ref;

  // Constructor for AuthController. It takes instances of AuthRepository and Ref as arguments.
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  // Getter for auth state changes stream from AuthRepository.
  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  // Method to sign in with Google. It sets the state to true before starting the sign in process. and sets it to false after the sign in process is completed.
  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
        (l) => showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

// Method to get user data. It calls the getUserData method from the AuthRepository.
  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  // Method to sign out. It calls the signOut method from the AuthRepository.
  void logOut() async {
     _authRepository.logOut();
  }
}

