// ignore_for_file: public_member_api_docs, sort_constructors_first, file_names
import 'dart:convert';

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String role;
  final String profilePhoto;
  final String contact;
  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.role,
    required this.profilePhoto,
    required this.contact,
  });

  User copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    String? role,
    String? profilePhoto,
    String? contact,
  }) {
    return User(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      role: role ?? this.role,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      contact: contact ?? this.contact,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'role': role,
      'profilePhoto': profilePhoto,
      'contact': contact,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      gender: map['gender'] as String,
      role: map['role'] as String,
      profilePhoto: map['profilePhoto'] as String,
      contact: map['contact'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(uid: $uid, firstName: $firstName, lastName: $lastName, email: $email, gender: $gender, role: $role, profilePhoto: $profilePhoto, contact: $contact)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.gender == gender &&
        other.role == role &&
        other.profilePhoto == profilePhoto &&
        other.contact == contact;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        gender.hashCode ^
        role.hashCode ^
        profilePhoto.hashCode ^
        contact.hashCode;
  }
}
