import 'package:order_approval/domain/entities/entities.dart';

abstract class Authentication {
  Future<UserEntity> auth(String email, String secret);
}