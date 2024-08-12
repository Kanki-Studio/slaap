import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider {
  static final provider = Provider((ref) => AuthService());

  static final authStateProvider = StreamProvider((ref) {
    return ref.watch(provider).firebase.authStateChanges();
  });
}

class AuthService {
  final FirebaseAuth firebase = FirebaseAuth.instance;

  Future<User> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleAuth == null) throw Exception("Authentication failed");

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final userCred = await firebase.signInWithCredential(credential);
    final user = userCred.user;
    if (user == null) throw Exception("Invalid authentication state");
    return user;
  }

  Future<void> signOut() async {
    await firebase.signOut();
  }
}
