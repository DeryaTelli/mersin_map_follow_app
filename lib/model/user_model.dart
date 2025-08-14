// lib/model/user_model.dart
class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender; // "male" | "female" | "other"
  final String role;
  final String? serverToken;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.role,
    this.serverToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    email: json['email'] as String,
    gender: json['gender'] as String,
    role: json['role'] as String,
    serverToken: json['server_token'] as String?,
  );

  
  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isUser  => role.toLowerCase() == 'user';
}
