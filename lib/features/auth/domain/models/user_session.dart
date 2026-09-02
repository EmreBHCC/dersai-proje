class UserSession {
  const UserSession({required this.fullName, required this.email});

  final String fullName;
  final String email;

  String get firstName {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.isEmpty ? fullName.trim() : parts.first;
  }

  UserSession copyWith({String? fullName, String? email}) {
    return UserSession(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
    );
  }
}
