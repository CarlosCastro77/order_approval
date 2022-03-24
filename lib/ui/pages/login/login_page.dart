import 'package:flutter/material.dart';

import './login.dart';
import '../../helpers/helpers.dart';

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
                  ),
                  onChanged: presenter.validateEmail,
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
                  ),
                  onChanged: presenter.validatePassword,
                );
              }
            ),
            StreamBuilder<bool>(
              stream: presenter.isFormValidStream,
              builder: (context, snapshot) {
                return ElevatedButton(
                  onPressed: snapshot.data == true 
                    ? presenter.authenticate
                    : null, 
                  child: const Text('Entrar')
                );
              }
            ),
            TextButton(
              onPressed: presenter.forgotPassword, 
              child: const Text('Esqueceu sua senha?')
            )
          ],
        ),
      ),
    );
  }
}
