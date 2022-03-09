import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/helpers/helpers.dart';

class FirebaseAuthentication {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthentication({
    required this.firebaseAuth
  });

  Future<void> auth({
    required String email, 
    required String secret
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: secret
      );
    } on FirebaseAuthException {
      throw DomainError.invalidCredentials;
    }
  }
}