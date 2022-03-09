import 'package:order_approval/domain/entities/entities.dart';

abstract class Authentication {
  Future<void> auth(String email, String secret);
}