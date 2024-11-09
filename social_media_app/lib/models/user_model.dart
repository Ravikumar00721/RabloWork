class UserModel {
  final int id;
  final String name;
  final String username;
  final String phone;
  final String website;
  final Address address;
  final Company company;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.website,
    required this.address,
    required this.company,
  });

  // Parse JSON into UserModel with new fields
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      phone: json['phone'],
      website: json['website'],
      address: Address.fromJson(json['address']), // Address
      company: Company.fromJson(json['company']), // Company
    );
  }
}

// Address Model to handle address data
class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  // Parse JSON into Address model
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      city: json['city'],
      zipcode: json['zipcode'],
    );
  }
}

// Company Model to handle company data
class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  // Parse JSON into Company model
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
      bs: json['bs'],
    );
  }
}
