class UserEntity {
  final String name;
  final String email;
  final String password;

  UserEntity({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          password == other.password;

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ password.hashCode;
}
