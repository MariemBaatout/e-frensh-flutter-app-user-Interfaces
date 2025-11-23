class User {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String userId;
  final String age;
  final String classe;

  User(
      {required this.name,
      required this.email,
      required this.phone,
      required this.password,
      required this.userId,
      required this.age,
      required this.classe});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      age: json['age'] as String? ?? '',
      classe: json['classe'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }
}
