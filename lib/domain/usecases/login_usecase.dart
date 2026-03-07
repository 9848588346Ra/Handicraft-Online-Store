import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<bool> call(String email, String password, {bool rememberMe = true}) async {
    return await repository.login(email, password, rememberMe: rememberMe);
  }
}
