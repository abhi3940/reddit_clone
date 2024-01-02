import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Provider for Firestore. Returns the same instance of FirebaseFirestore.
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Provider for FirebaseAuth. Returns the same instance of FirebaseAuth.
final authProvider = Provider((ref) => FirebaseAuth.instance);

// Provider for Firebase Storage. Returns the same instance of FirebaseStorage.
final storageProvider = Provider((ref) => FirebaseStorage.instance);

// Provider for Google Sign-In. Returns a new instance of GoogleSignIn.
final googleSignInProvider = Provider((ref) => GoogleSignIn());

// learned about singleton here...