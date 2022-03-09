import 'package:test/test.dart';

import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

enum DomainError {
  invalidCredentials
}

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

class FirebaseAuthSpy extends Mock implements FirebaseAuth {
  When mockSignInCall() => 
    when(() => 
      signInWithEmailAndPassword(
        email: any(named: 'email'), 
        password: any(named: 'password')
      )
    );
  
  void mockSignIn(UserCredential userCredential) => 
    mockSignInCall().thenAnswer((_) async => userCredential);

  void mockSignInError(FirebaseAuthException error) => mockSignInCall().thenThrow(error);
}

class UserCredentialsFake extends Fake implements UserCredential {}

void main() {
  // spy
  late FirebaseAuthSpy firebaseAuth;
  
  // fakes
  late String fakeEmail;
  late String fakeSecret;
  late UserCredentialsFake fakeUserCredentials;

  late FirebaseAuthentication sut;

  setUp(() {
    // spy
    firebaseAuth = FirebaseAuthSpy();

    // fakes
    fakeEmail = faker.internet.email();
    fakeSecret = faker.internet.password();
    fakeUserCredentials = UserCredentialsFake();
    
    // mocks
    firebaseAuth.mockSignIn(fakeUserCredentials);

    sut = FirebaseAuthentication(firebaseAuth: firebaseAuth);
  });

  test('Should call sign in with correct email and password', () async {
    await sut.auth(
      email: fakeEmail,
      secret: fakeSecret
    );

    verify(() => firebaseAuth.signInWithEmailAndPassword(
      email: fakeEmail, 
      password: fakeSecret
    ));
  });

  test('Should throw invalid credentials error if email is invalid', () {
    firebaseAuth.mockSignInError(FirebaseAuthException(code: 'invalid-email'));

    final auth = sut.auth(
      email: fakeEmail,
      secret: fakeSecret
    );

    expect(auth, throwsA(DomainError.invalidCredentials));
  });

  test('Should throw invalid credentials error if password is invalid', () {
    firebaseAuth.mockSignInError(FirebaseAuthException(code: 'wrong-password'));

    final auth = sut.auth(
      email: fakeEmail,
      secret: fakeSecret
    );

    expect(auth, throwsA(DomainError.invalidCredentials));
  });
}