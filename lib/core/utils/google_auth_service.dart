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

      if (_googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = _googleUser!.authentication;
      final String? idToken = googleAuth.idToken;

      final authorizationClient = _googleUser!.authorizationClient;
      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);

      String? accessToken = authorization?.accessToken;

      if (accessToken == null) {
        final auth2 =
            await authorizationClient.authorizeScopes(['email', 'profile']);
        accessToken = auth2.accessToken;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        String? firebaseIdToken = await user.getIdToken();
        return firebaseIdToken;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> reAuthenticate() async {
    try {
      _googleUser = await _googleSignIn.authenticate();
      return _googleUser != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (e) {}
    _googleUser = null;
    await _auth.signOut();
  }
}
