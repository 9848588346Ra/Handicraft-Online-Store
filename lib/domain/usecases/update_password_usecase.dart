import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository repository;

  UpdatePasswordUseCase(this.repository);

  Future<void> call(String email, String newPassword) async {
    return await repository.updatePassword(email, newPassword);
  }
}
