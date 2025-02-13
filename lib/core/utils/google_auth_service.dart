import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:style_me/core/extensions/global_ext.dart';

class GoogleAuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  GoogleAuthService(this._auth, this._googleSignIn);

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        String? idToken = await user.getIdToken();
        return idToken;
      }
    } catch (e) {
      debugMessagePrint("Error signing in with Google: $e");
      return null;
    }
    return null;
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
