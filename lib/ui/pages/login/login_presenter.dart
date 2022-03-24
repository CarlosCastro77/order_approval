import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

abstract class LoginPresenter implements Listenable {
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<bool> get isFormValidStream;

  void authenticate();
  void forgotPassword();
  void validateEmail(String email);
  void validatePassword(String password);
}