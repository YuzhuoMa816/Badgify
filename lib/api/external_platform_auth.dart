import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../main.dart';

class ExternalAuth {
  Future<User> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);

      final User currentUser = FirebaseAuth.instance.currentUser!;
      assert(user.uid == currentUser.uid);

      print(user.email);

      await googleSignIn.signOut();

      return user;
    } else {
      appStore.setLoading(false);
      throw Exception("USER_NOT_CREATED");
    }
  }

  Future<User> appleSignIn() async {
    print("in");
    if (await TheAppleSignIn.isAvailable()) {
      AuthorizationResult result = await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      print(result.status);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
          );

          final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
          final user = authResult.user!;

          return user;
        case AuthorizationStatus.error:
          throw ("${language.lblSignInFailed}: ${result.error!.localizedDescription}");
        case AuthorizationStatus.cancelled:
          throw (language.lblUserCancelled);

      }
    } else {
      throw language.appleSignInNotAvailable;
    }
  }



}
