import 'package:flutter/foundation.dart';

class UserModels {
  final String uid;
  final String email;
  final String? fullName;
  final String? photoUrl;
  final String role;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  final List<FamilyMember> familyMembers;

  UserModels({
    required this.uid,
    required this.email,
    this.fullName,
    required this.role,
    this.photoUrl,
    required this.createdAt,
    required this.lastLoginAt,
    this.familyMembers = const [],
  });

  factory UserModels.fromJson(Map<String, dynamic> json) {
    return UserModels(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      fullName: json['fullName'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : DateTime.now(),

      familyMembers:
          (json['familyMembers'] as List<dynamic>?)
              ?.map(
                (memberJson) =>
                    FamilyMember.fromJson(memberJson as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'role': role,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'familyMembers': familyMembers.map((member) => member.toJson()).toList(),
    };
  }

  UserModels copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? photoUrl,
    DateTime? createdAt,
    String? role,
    DateTime? lastLoginAt,
    List<FamilyMember>? familyMembers,
  }) {
    return UserModels(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      familyMembers: familyMembers ?? this.familyMembers,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModels &&
        other.uid == uid &&
        other.email == email &&
        other.fullName == fullName &&
        other.photoUrl == photoUrl &&
        other.role == role &&
        listEquals(other.familyMembers, familyMembers);
  }

  @override
  int get hashCode {
    return Object.hash(uid, email, fullName, photoUrl, role, familyMembers);
  }

  @override
  String toString() {
    return 'UserModels(id: $uid, email: $email, fullName: $fullName, role: $role, familyMembers: ${familyMembers.length})';
  }
}

class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final DateTime addedAt;
  final String? photoUrl;
  final bool isActive;

  FamilyMember({
    required this.id,
    required this.name,
    required this.addedAt,
    required this.relation,
    this.photoUrl,
    this.isActive = true,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
      isActive: json['isActive'] ?? true,
      relation: json['relation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'photoUrl': photoUrl,
      'addedAt': addedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  FamilyMember copyWith({
    String? id,
    String? name,
    String? relation,
    String? photoUrl,
    DateTime? addedAt,
    bool? isActive,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      addedAt: addedAt ?? this.addedAt,
      relation: relation ?? this.relation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FamilyMember &&
        other.id == id &&
        other.name == name &&
        other.relation == relation &&
        other.photoUrl == photoUrl &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, relation, photoUrl, isActive);
  }

  @override
  String toString() {
    return 'FamilyMember(id : $id, name: $name, relation: $relation, isActive: $isActive)';
  }
}

enum FamilyRelation {
  spouse('Spouse'),
  child('Child'),
  parent('Parent'),
  sibling('Sibling'),
  other('Other'),
  grandparent('GrandParent'),
  grandchild('GrandChild');

  const FamilyRelation(this.displayName);
  final String displayName;
  static FamilyRelation fromString(String relation) {
    return FamilyRelation.values.firstWhere(
      (e) => e.displayName.toLowerCase() == relation.toLowerCase(),
      orElse: () => FamilyRelation.other,
    );
  }
}
