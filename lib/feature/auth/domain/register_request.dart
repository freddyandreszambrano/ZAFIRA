class RegisterRequest {
  const RegisterRequest({
    required this.username,
    required this.email,
    required this.dni,
    required this.password,
    this.firstName = '',
    this.lastName = '',
    this.gender = '',
    this.preferredSize = '',
  });

  final String username;
  final String email;
  final String dni;
  final String password;
  final String firstName;
  final String lastName;
  final String gender;
  final String preferredSize;

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'dni': dni,
    'password': password,
    'first_name': firstName,
    'last_name': lastName,
    'gender': gender,
    'preferred_size': preferredSize,
  };
}
