import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error registering user: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<void> updateUsername(String newUsername) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.updateProfile(displayName: newUsername);
      }
    } catch (e) {
      print("Error updating username: $e");
      throw e;
    }
  }

  Future<void> updateBio(String newBio) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
          'bio': newBio,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print("Error updating bio: $e");
      throw e;
    }
  }

  Future<String?> getBio() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        return documentSnapshot.get('bio');
      }
      return null;
    } catch (e) {
      print("Error getting bio: $e");
      throw e;
    }
  }

  Future<String?> uploadProfilePicture(File file) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        TaskSnapshot snapshot = await _storage
            .ref()
            .child('profile_pictures/${currentUser.uid}')
            .putFile(file);
        String downloadURL = await snapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({
          'profilePicture': downloadURL,
        }, SetOptions(merge: true));
        return downloadURL;
      }
    } catch (e) {
      print("Error uploading profile picture: $e");
      throw e;
    }
    return null;
  }

  Future<String?> getProfilePicture() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        return documentSnapshot.get('profilePicture');
      }
      return null;
    } catch (e) {
      print("Error getting profile picture: $e");
      throw e;
    }
  }
}
