enum Gender { male, female }

class AppUser {
  final String id;
  final String email;
  final String? displayName;
  final Gender gender;

  const AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.gender,
  });
}
