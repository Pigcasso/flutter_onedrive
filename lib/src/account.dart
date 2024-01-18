class Account {
  final String mail;

  Account({
    required this.mail,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      mail: json["mail"],
    );
  }
}
