import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Email')
              )
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('Senha')
              )
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
  testWidgets('Should render with correct initial state', (WidgetTester tester) async {
    const loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Esqueceu sua senha?'), findsOneWidget);
  });
}