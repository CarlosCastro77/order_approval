import 'package:test/test.dart';

import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

class RiverpodLoginPagePresenter {
  final Validation validation;

  RiverpodLoginPagePresenter({
    required this.validation
  });

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

abstract class Validation {
  void validate({
    required String field,
    required String value
  });
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  late Validation validation;
  late RiverpodLoginPagePresenter sut;
  late String fakeEmail;

  setUp(() {
    fakeEmail = faker.internet.email();
    sut = RiverpodLoginPagePresenter(validation: validation);
    validation = ValidationSpy();
  });

  test('Should call Validation with correct email', () async {
    sut.validateEmail(fakeEmail);

    verify(() => validation.validate(field: 'email', value: fakeEmail)).called(1);
  });
}