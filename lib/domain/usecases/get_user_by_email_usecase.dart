import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetUserByEmailUseCase {
  final AuthRepository repository;

  GetUserByEmailUseCase(this.repository);

  Future<UserEntity?> call(String email) async {
    return await repository.getUserByEmail(email);
  }
}
