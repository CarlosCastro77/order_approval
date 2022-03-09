import 'package:order_approval/domain/entities/entities.dart';

abstract class EmailAuthentication {
  Future<void> auth({required String email, required String secret});
}