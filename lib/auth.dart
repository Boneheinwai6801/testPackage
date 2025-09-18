import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social/model/model.dart';

class AuthService {
  Future<void> signOutGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await auth.signOut();

      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      log("Signed out successfully.");
    } catch (e) {
      log("Sign out error: $e");
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (userCred.user != null) {
        AuthUserData userData = AuthUserData.fromFirebaseUser(
          uid: userCred.user!.uid,
          name: userCred.user!.displayName,
          email: userCred.user!.email,
          photoUrl: userCred.user!.photoURL,
          token: googleAuth.accessToken,
        );
        log(
          "User signed in: ${userData.name}, ${userData.email}, token: ${userData.token}",
        );
        // await UserLocalStorage.saveUser(userCred.user!, "google");
      }
      return userCred;
    } catch (e) {
      log("Google sign-in error: $e");
      return null;
    }
  }

  // static Future<UserCredential?> signInWithFacebook() async {
  //   try {
  //     final result = await FacebookAuth.instance.login();
  //     if (result.status != LoginStatus.success) return null;

  //     final credential =
  //         FacebookAuthProvider.credential(result.accessToken!.tokenString);
  //     final userCred =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     if (userCred.user != null) {
  //       await UserLocalStorage.saveUser(userCred.user!, "facebook");
  //     }
  //     return userCred;
  //   } catch (e) {
  //     log("Facebook sign-in error: $e");
  //     return null;
  //   }
  // }
}
