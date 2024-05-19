// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DocumentModel {
  final String name;
  final String type;
  final List<String> images;
  final DateTime foundAt;
  final String host;
  final String location;
  DocumentModel({
    required this.name,
    required this.type,
    required this.images,
    required this.foundAt,
    required this.host,
    required this.location,
  });

  DocumentModel copyWith({
    String? name,
    String? type,
    List<String>? images,
    DateTime? foundAt,
    String? host,
    String? location,
  }) {
    return DocumentModel(
      name: name ?? this.name,
      type: type ?? this.type,
      images: images ?? this.images,
      foundAt: foundAt ?? this.foundAt,
      host: host ?? this.host,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'images': images,
      'foundAt': foundAt.millisecondsSinceEpoch,
      'host': host,
      'location': location,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      name: map['name'] as String,
      type: map['type'] as String,
      images: List<String>.from((map['images'] as List<String>)),
      foundAt: DateTime.fromMillisecondsSinceEpoch(map['foundAt'] as int),
      host: map['host'] as String,
      location: map['location'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DocumentModel(name: $name, type: $type, images: $images, foundAt: $foundAt, host: $host, location: $location)';
  }

  @override
  bool operator ==(covariant DocumentModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.type == type &&
        listEquals(other.images, images) &&
        other.foundAt == foundAt &&
        other.host == host &&
        other.location == location;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        type.hashCode ^
        images.hashCode ^
        foundAt.hashCode ^
        host.hashCode ^
        location.hashCode;
  }
}
