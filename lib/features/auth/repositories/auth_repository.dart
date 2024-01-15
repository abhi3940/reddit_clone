// Importing necessary packages and modules.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants/Firebase_constants.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/models/user_model.dart';

// Provider for AuthRepository. It uses other providers to get instances of Firestore, FirebaseAuth and GoogleSignIn.
final authRepositoryProvider = Provider(((ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    firebaseAuth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider))));

// AuthRepository class. It handles all the authentication related tasks.
class AuthRepository {
  // Private instance of FirebaseFirestore.
  final FirebaseFirestore _firestore;
  // Private instance of FirebaseAuth.
  final FirebaseAuth _auth;
  // Private instance of GoogleSignIn.
  final GoogleSignIn _googleSignIn;

  // Constructor for AuthRepository. It takes instances of Firestore, FirebaseAuth and GoogleSignIn as arguments.
  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _auth = firebaseAuth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  // Getter for 'users' collection in Firestore.
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  // Getter for auth state changes stream from FirebaseAuth.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Method to sign in with Google. It returns a FutureEither<UserModel>.
  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      // get authentication credientials from google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      //store those in userCredential to use and then use them to sign in in the firebase
      UserCredential userCredential;
      if (isFromLogin) {
        userCredential =
          await _auth.signInWithCredential(credential);
      }else{
        userCredential =
          await _auth.currentUser!.linkWithCredential(credential);}

      UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No name',
          profilePic: userCredential.user?.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [
            'til',
            'gold',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'awesomeAns'
          ],
        );
        // Saving the new user model to the Firestore database.
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        // If the user is not new, retrieving the user's data from Firestore.
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      // Returning the user model wrapped in a Right object, indicating a successful operation.
      return right(userModel);
    } on FirebaseException catch (e) {
      // Catching any Firebase exceptions that occur during the operation and throwing the error message.
      throw e.message!;
    } catch (e) {
      // Catching any other exceptions that occur during the operation and returning a Failure object wrapped in a Left object, indicating an unsuccessful operation.
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      var userCredential = await _auth.signInAnonymously();

      UserModel userModel = UserModel(
        name: 'Guest',
        profilePic: Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: false,
        karma: 0,
        awards: [],
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // This method retrieves a user's data from Firestore and maps it to a UserModel object.
  // It returns a Stream<UserModel>, which means it provides the user model in a stream that updates whenever the user's data changes in Firestore.
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
