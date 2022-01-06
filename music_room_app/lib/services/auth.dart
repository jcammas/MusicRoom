import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_room_app/widgets/sign_in_type.dart';

abstract class AuthBase {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<User?> signInWithGoogle();

  Future<User?> signInWithFacebook();

  Future<void> signInWithEmail(
      {required String email, required String password});

  Future<User?> createUserWithEmail(
      {required String email, required String password});

  Future<void> updateUserEmail(String newEmail);

  Future<void> updateUserName(String newName);

  Future<void> updateUserPassword(String newPassword);

  Future<void> deleteCurrentUser();

  Future<void> reAuthenticateUser(String password);

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();

  SignInType findSignInType();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (currentUser == null) {
        await signOut();
        throw FirebaseAuthException(
            code: 'ERROR_NO_USER', message: 'User could not be found.');
      }
      currentUser!.reload();
      if (currentUser!.emailVerified == false) {
        await currentUser!.sendEmailVerification();
        await signOut();
        throw FirebaseAuthException(
            code: 'ERROR_EMAIL_NOT_VERIFIED',
            message:
                'You have to verify your email ! Check your inbox. An email has been resent.');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> createUserWithEmail(
      {required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await currentUser!.reload();
      await currentUser!.sendEmailVerification();
      await signOut();
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthCredential> _getGoogleCredentials() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        return (GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    try {
      final userCredential = await _firebaseAuth
          .signInWithCredential(await _getGoogleCredentials());
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthCredential> _getFacebookCredentials() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        return FacebookAuthProvider.credential(accessToken!.token);
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error!.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User?> signInWithFacebook() async {
    try {
      final userCredential = await _firebaseAuth
          .signInWithCredential(await _getFacebookCredentials());
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserEmail(String newEmail) async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser?.updateEmail(newEmail);
        await _firebaseAuth.currentUser?.sendEmailVerification();
      } else {
        throw FirebaseAuthException(
          code: 'NO_USER_CONNECTED',
          message: 'User has been disconnected',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserName(String newName) async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser?.updateDisplayName(newName);
      } else {
        throw FirebaseAuthException(
          code: 'NO_USER_CONNECTED',
          message: 'User has been disconnected',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserPassword(String newPassword) async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.currentUser?.updatePassword(newPassword);
      } else {
        throw FirebaseAuthException(
          code: 'NO_USER_CONNECTED',
          message: 'User has been disconnected',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  SignInType findSignInType() {
    if (currentUser != null &&
        currentUser!.providerData.first.providerId == 'google.com') {
      return SignInType.google;
    } else if (currentUser != null &&
        currentUser!.providerData.first.providerId == 'facebook.com') {
      return SignInType.facebook;
    } else {
      return SignInType.email;
    }
  }

  @override
  Future<void> reAuthenticateUser(String password) async {
    try {
      final AuthCredential credential;
      final SignInType type = findSignInType();
      if (currentUser != null && currentUser?.email != null) {
        if (type == SignInType.google) {
          credential = await _getGoogleCredentials();
        } else if (type == SignInType.facebook) {
          credential = await _getFacebookCredentials();
        } else {
          credential = EmailAuthProvider.credential(
              email: currentUser!.email!, password: password);
        }
        await currentUser?.reauthenticateWithCredential(credential);
      } else {
        throw FirebaseAuthException(
          code: 'NO_USER_CONNECTED',
          message: 'User has been disconnected',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCurrentUser() async {
    try {
      if (currentUser != null) {
        await _firebaseAuth.currentUser?.delete();
      } else {
        throw FirebaseAuthException(
          code: 'NO_USER_CONNECTED',
          message: 'User has been disconnected',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
  }
}
