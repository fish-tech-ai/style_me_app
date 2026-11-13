import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:style_me/core/extensions/global_ext.dart';

class GoogleAuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _googleUser;

  GoogleAuthService(this._auth, this._googleSignIn);

  Future<String?> signInWithGoogle() async {
    try {
      _googleUser = await _googleSignIn.authenticate();
      final String? idToken = _googleUser?.authentication.idToken;

      if (idToken == null) {
        debugMessagePrint("Google sign-in error: missing ID token");
        return null;
      }

      final UserCredential userCredential = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: idToken),
      );
      final User? user = userCredential.user;

      if (user == null) {
        debugMessagePrint("Google sign-in error: missing Firebase user");
        return null;
      }

      return await user.getIdToken();
    } catch (e) {
      debugMessagePrint("Google sign-in error: $e");
      return null;
    }
  }

  Future<bool> reAuthenticate() async {
    try {
      _googleUser = await _googleSignIn.authenticate();
      return _googleUser != null;
    } catch (e) {
      debugMessagePrint("Google re-authentication error: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      debugMessagePrint("Google sign-out error: $e");
    }
    _googleUser = null;
    await _auth.signOut();
  }
}
