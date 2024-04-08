class UserSessionData {
  final String name;
  final String token;
  const UserSessionData({
    required this.name,
    required this.token,
  });

  factory UserSessionData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'token': String token,
      } =>
        UserSessionData(name: name, token: token),
      _ => throw const FormatException('Failed to load album'),
    };
  }
}
