class AppUser {
  final String id;
  final String email;
  int coins;

  AppUser({
    required this.id,
    required this.email,
    this.coins = 0,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      coins: json['coins'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'coins': coins,
      };
}