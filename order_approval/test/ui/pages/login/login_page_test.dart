import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

enum UIError {
  requiredField,
  invalidField,
}

extension UIErrorExtension on UIError {
  String get description {
    switch(this) {
      case UIError.requiredField: return 'Campo obrigatório';
      case UIError.invalidField: return 'Campo inválido';
    }
  }
}

abstract class LoginPresenter implements Listenable {
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
}

class LoginPresenterSpy extends Mock implements LoginPresenter {
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();

  LoginPresenterSpy() {
    when(() => emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
  }

  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitPasswordError(UIError error) => passwordErrorController.add(error);

  void dispose() {
    emailErrorController.close();
    passwordErrorController.close();
  }
}

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            StreamBuilder<UIError?>(
              stream: presenter.emailErrorStream,
              builder: (context, snapshot) {
                return TextFormField(
                  decoration: InputDecoration(
                    label: const Text('Email'),
                    errorText: snapshot.data?.description
                  )
                );
              }
            ),
            StreamBuilder<UIError?>(
              stream: presenter.passwordErrorStream,
              builder: (context, snapshot) {
                return TextFormField(
                  decoration: InputDecoration(
                    label: const Text('Senha'),
                    errorText: snapshot.data?.description
                  )
                );
              }
            ),
            ElevatedButton(
              onPressed: () {}, 
              child: const Text('Entrar')
            ),
            TextButton(
              onPressed: () {}, 
              child: const Text('Esqueceu sua senha?')
            )
          ],
        ),
      ),
    );
  }
}

void main() {
  late LoginPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }
  
  testWidgets('Should render with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Esqueceu sua senha?'), findsOneWidget);
  });

  testWidgets('Should present error if email is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);
  });

  testWidgets('Should present error if email is empty', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitEmailError(UIError.requiredField);
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('Should present error if password is invalid', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitPasswordError(UIError.invalidField);
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);
  });
}