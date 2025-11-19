class PasswordItem {
  final String id;
  final String serviceName;
  final String username;
  final String password;
  final String? notes;

  PasswordItem({
    required this.id,
    required this.serviceName,
    required this.username,
    required this.password,
    this.notes,
  });

  PasswordItem copyWith({
    String? id,
    String? serviceName,
    String? username,
    String? password,
    String? notes,
  }) {
    return PasswordItem(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      username: username ?? this.username,
      password: password ?? this.password,
      notes: notes ?? this.notes,
    );
  }
}
