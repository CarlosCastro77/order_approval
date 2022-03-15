import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';

class FirebaseEmailAuthentication implements EmailAuthentication {
  final FirebaseAuth firebaseAuth;

  FirebaseEmailAuthentication({
    required this.firebaseAuth
  });

  @override
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