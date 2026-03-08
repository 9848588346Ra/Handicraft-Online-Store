import '../repositories/auth_repository.dart';

class RestoreSessionFromBiometricUseCase {
  final AuthRepository repository;

  RestoreSessionFromBiometricUseCase(this.repository);

  Future<void> call(String email, String name) async {
    await repository.restoreSessionFromBiometric(email, name);
  }
}
