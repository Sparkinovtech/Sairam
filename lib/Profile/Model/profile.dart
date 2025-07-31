import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sairam_incubation/Profile/Model/certificate.dart';
import 'package:sairam_incubation/Profile/Model/department.dart';
import 'package:sairam_incubation/Profile/Model/domains.dart';
import 'package:sairam_incubation/Profile/Model/link.dart';
import 'package:sairam_incubation/Profile/Model/media_items.dart';

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
  final String? resume;
  final String? currentMentor;
  final String? collegeIdPhoto;
  final List<Domains>? domains;
  final List<Domains>? skillSet;
  final List<Link>? links;
  final List<MediaItems>? mediaList;
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
    this.resume,
    this.domains,
    this.skillSet,
    this.mediaList,
    this.links,
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
      'resume': resume,
      'yearOfGraduation': yearOfGraduation,
      'currentYear': currentYear,
      'currentMentor': currentMentor,
      'collegeIdPhoto': collegeIdPhoto,
      'domains': domains?.map((d) => d.name).toList(),
      'skillSet': skillSet?.map((s) => s.name).toList(),
      'mediaList': mediaList?.map((m) => m.toJson()).toList(),
      'links': links?.map((l) => l.toJson()).toList(),
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
      resume: json['resume'] as String?,
      domains: (json['domains'] as List<dynamic>?)
          ?.map((d) => Domains.values.byName(d))
          .toList(),
      skillSet: (json['skillSet'] as List<dynamic>?)
          ?.map((s) => Domains.values.byName(s))
          .toList(),
      mediaList: (json['mediaList'] as List<dynamic>?)
          ?.map((m) => MediaItems.fromJson(m as Map<String, dynamic>))
          .toList(),
      links: (json['links'] as List<dynamic>?)
          ?.map((l) => Link.fromJson(l as Map<String, dynamic>))
          .toList(),
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((c) => Certificate.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Profile('
        'name: $name, '
        'emailAddresss: $emailAddresss, '
        'phoneNumber: $phoneNumber, '
        'department: ${department?.name}, '
        'dateOfBirth: $dateOfBirth, '
        'id: $id, '
        'profilePicture: $profilePicture, '
        'yearOfGraduation: $yearOfGraduation, '
        'currentYear: $currentYear, '
        'currentMentor: $currentMentor, '
        'collegeIdPhoto: $collegeIdPhoto, '
        'domains: ${domains?.map((d) => d.name).toList()}, '
        'skillSet: ${skillSet?.map((s) => s.name).toList()}, '
        'mediaList: ${mediaList?.length}, '
        'links: ${links?.length}, '
        'certificates: ${certificates?.length}'
        ')';
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
    String? resume,
    int? yearOfGraduation,
    int? currentYear,
    String? currentMentor,
    String? collegeIdPhoto,
    List<Domains>? domains,
    List<Domains>? skillSet,
    List<MediaItems>? mediaList,
    List<Link>? links,
    List<Certificate>? certificates,
  }) {
    return Profile(
      name: name ?? this.name,
      emailAddresss: emailAddresss ?? this.emailAddresss,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      department: department ?? this.department,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      id: id ?? this.id,
      resume: resume ?? this.resume,
      profilePicture: profilePicture ?? this.profilePicture,
      yearOfGraduation: yearOfGraduation ?? this.yearOfGraduation,
      currentYear: currentYear ?? this.currentYear,
      currentMentor: currentMentor ?? this.currentMentor,
      collegeIdPhoto: collegeIdPhoto ?? this.collegeIdPhoto,
      domains: domains ?? this.domains,
      skillSet: skillSet ?? this.skillSet,
      mediaList: mediaList ?? this.mediaList,
      links: links ?? this.links,
      certificates: certificates ?? this.certificates,
    );
  }
}
