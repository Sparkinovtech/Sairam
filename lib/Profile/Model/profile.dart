import 'package:flutter/material.dart';
import 'package:sairam_incubation/Profile/Model/certificate.dart';
import 'package:sairam_incubation/Profile/Model/department.dart';
import 'package:sairam_incubation/Profile/Model/domains.dart';
import 'package:flutter/foundation.dart'; // For @immutable

@immutable
class Profile {
  final String? name;
  final String? emailAddresss;
  final String? phoneNumber;
  final Department? department;
  final String? dateOfBirth;
  final String? id;
  final String? profilePicture;
  final int? yearOfGraduation;
  final int? currentYear;
  final String? currentMentor;
  final String? collegeIdPhoto;
  final List<Domains>? domains;
  final List<Domains>? skillSet;
  final List<Certificate>? certificates;

  const Profile({
    this.name,
    this.emailAddresss,
    this.phoneNumber,
    this.department,
    this.dateOfBirth,
    this.id,
    this.profilePicture,
    this.yearOfGraduation,
    this.currentYear,
    this.currentMentor,
    this.collegeIdPhoto,
    this.domains,
    this.skillSet,
    this.certificates,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emailAddresss': emailAddresss,
      'phoneNumber': phoneNumber,
      'department': department?.name,
      'dateOfBirth': dateOfBirth,
      'id': id,
      'profilePicture': profilePicture,
      'yearOfGraduation': yearOfGraduation,
      'currentYear': currentYear,
      'currentMentor': currentMentor,
      'collegeIdPhoto': collegeIdPhoto,
      'domains': domains?.map((d) => d.name).toList(),
      'skillSet': skillSet?.map((s) => s.name).toList(),
      'certificates': certificates?.map((c) => c.toJson()).toList(),
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] as String?,
      emailAddresss: json['emailAddresss'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      department: json['department'] != null
          ? Department.values.byName(json['department'])
          : null,
      dateOfBirth: json['dateOfBirth'] as String?,
      id: json['id'] as String?,
      profilePicture: json['profilePicture'] as String?,
      yearOfGraduation: json['yearOfGraduation'] as int?,
      currentYear: json['currentYear'] as int?,
      currentMentor: json['currentMentor'] as String?,
      collegeIdPhoto: json['collegeIdPhoto'] as String?,
      domains: (json['domains'] as List<dynamic>?)
          ?.map((d) => Domains.values.byName(d))
          .toList(),
      skillSet: (json['skillSet'] as List<dynamic>?)
          ?.map((s) => Domains.values.byName(s))
          .toList(),
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((c) => Certificate.fromJson(c))
          .toList(),
    );
  }
}

extension ProfileCopyWith on Profile {
  Profile copyWith({
    String? name,
    String? emailAddresss,
    String? phoneNumber,
    Department? department,
    String? dateOfBirth,
    String? id,
    String? profilePicture,
    int? yearOfGraduation,
    int? currentYear,
    String? currentMentor,
    String? collegeIdPhoto,
    List<Domains>? domains,
    List<Domains>? skillSet,
    List<Certificate>? certificates,
  }) {
    return Profile(
      name: name ?? this.name,
      emailAddresss: emailAddresss ?? this.emailAddresss,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      id: id ?? this.id,
      profilePicture: profilePicture ?? this.profilePicture,
      yearOfGraduation: yearOfGraduation ?? this.yearOfGraduation,
      currentYear: currentYear ?? this.currentYear,
      currentMentor: currentMentor ?? this.currentMentor,
      collegeIdPhoto: collegeIdPhoto ?? this.collegeIdPhoto,
      domains: domains ?? this.domains,
      skillSet: skillSet ?? this.skillSet,
      certificates: certificates ?? this.certificates,
    );
  }
}
