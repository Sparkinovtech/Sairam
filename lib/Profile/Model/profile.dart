import 'package:flutter/material.dart';
import 'package:sairam_incubation/Profile/Model/certificate.dart';
import 'package:sairam_incubation/Profile/Model/department.dart';
import 'package:sairam_incubation/Profile/Model/domains.dart';

@immutable
class Profile {
  final String name;
  final String emailAddresss;
  final String phoneNumber;
  final Department department;
  final String dateOfBirth;
  final String id;
  final String profilePicture;
  final int yearOfGraduation;
  final int currentYear;
  final String currentMentor;
  final String collegeIdPhoto;
  final List<Domains> domains;
  final List<Domains> skillSet;
  final List<Certificate> certificates;

  Profile(
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
  );
}
