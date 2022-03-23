import 'dart:async';

import 'package:mocktail/mocktail.dart';

import 'package:order_approval/ui/helpers/helpers.dart';
import 'package:order_approval/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {
  final emailErrorController = StreamController<UIError?>();
  final passwordErrorController = StreamController<UIError?>();
  final isFormValidController = StreamController<bool>();

  LoginPresenterSpy() {
    when(() => emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(() => isFormValidStream).thenAnswer((_) => isFormValidController.stream);
  }

  void emitEmailError(UIError error) => emailErrorController.add(error);
  void emitEmailValid() => emailErrorController.add(null);
  void emitPasswordError(UIError error) => passwordErrorController.add(error);
  void emitPasswordValid() => passwordErrorController.add(null);
  void emitFormValid() => isFormValidController.add(true);
  void emitFormInvalid() => isFormValidController.add(false);

  void dispose() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
  }
}