class UserModel {
  final int id;
  final String name;
  final String username;
  final String email;

  UserModel({required this.id, required this.name, required this.username, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }
}

class Address {
  final String street;
  final String city;

  Address({required this.street, required this.city});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
    );
  }
}
