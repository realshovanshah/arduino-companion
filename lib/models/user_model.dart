import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  String id;
  final String address;
  String password;
  final String contact;

  UserModel({
    this.name,
    this.email,
    this.id,
    this.address,
    this.password,
    this.contact,
  });

  UserModel copyWith({
    String name,
    String email,
    String id,
    String address,
    String password,
    String contact,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      address: address ?? this.address,
      password: password ?? this.password,
      contact: contact ?? this.contact,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'address': address,
      'password': password,
      'contact': contact,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      id: map['id'],
      address: map['address'],
      password: map['password'],
      contact: map['contact'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, id: $id, address: $address, password: $password, contact: $contact)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.email == email &&
        other.id == id &&
        other.address == address &&
        other.password == password &&
        other.contact == contact;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        id.hashCode ^
        address.hashCode ^
        password.hashCode ^
        contact.hashCode;
  }
}
