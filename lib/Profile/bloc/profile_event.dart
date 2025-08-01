import 'package:flutter/material.dart';
import 'package:sairam_incubation/Profile/Model/certificate.dart';
import 'package:sairam_incubation/Profile/Model/department.dart';
import 'package:sairam_incubation/Profile/Model/domains.dart';
import 'package:sairam_incubation/Profile/Model/link.dart';
import 'package:sairam_incubation/Profile/Model/media_items.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class RegisterProfileInformationEvent extends ProfileEvent {
  final String? profilePic;
  final String fullName;
  final String emailAddress;
  final String phoneNumber;
  final Department department;
  final String dateOfBirth;

  const RegisterProfileInformationEvent({
    required this.profilePic,
    required this.fullName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.department,
    required this.dateOfBirth,
  });
}

class RegisterIdentityDetailsEvent extends ProfileEvent {
  final String studentId;
  final Department department;
  final int currentYear;
  final int yearOfGraduation;
  final String mentorName;
  final String idCardPhoto;

  const RegisterIdentityDetailsEvent({
    required this.studentId,
    required this.department,
    required this.currentYear,
    required this.yearOfGraduation,
    required this.mentorName,
    required this.idCardPhoto,
  });
}

class RegisterWorkPreferencesEvent extends ProfileEvent {
  final List<Domains>? domains;

  const RegisterWorkPreferencesEvent({required this.domains});
}

class RegisterSkillSetEvent extends ProfileEvent {
  final List<Domains> domains;
  final String resumeFile;

  const RegisterSkillSetEvent({
    required this.domains,
    required this.resumeFile,
  });
}

class RegisterPortfolioEvent extends ProfileEvent {
  final List<Link> links;
  final List<MediaItems> mediaList;

  const RegisterPortfolioEvent({required this.links, required this.mediaList});
}

class RegisterCertificateEvent extends ProfileEvent {
  final List<Certificate> certificates;

  const RegisterCertificateEvent({required this.certificates});
}

class AddPortfolioLinkEvent extends ProfileEvent {
  final Link link;

  const AddPortfolioLinkEvent({required this.link});
}

class DeletePortfolioLinkEvent extends ProfileEvent {
  final Link link;

  const DeletePortfolioLinkEvent({required this.link});
}

class AddPortfolioMediaEvent extends ProfileEvent {
  final MediaItems mediaItem;

  const AddPortfolioMediaEvent({required this.mediaItem});
}

class DeletePortfolioMediaEvent extends ProfileEvent {
  final MediaItems mediaItem;

  const DeletePortfolioMediaEvent({required this.mediaItem});
}

class UpdatePortfolioMediaEvent extends ProfileEvent {
  final MediaItems mediaItem;

  const UpdatePortfolioMediaEvent({required this.mediaItem});
}

/// Adds a single certificate to the user's profile (for immediate, incremental add)
class AddCertificateEvent extends ProfileEvent {
  final Certificate certificate;

  const AddCertificateEvent({required this.certificate});
}

/// Updates (edits) an existing certificate in the user's profile
class UpdateCertificateEvent extends ProfileEvent {
  final Certificate oldCertificate;
  final Certificate newCertificate;

  const UpdateCertificateEvent({
    required this.oldCertificate,
    required this.newCertificate,
  });
}

/// Deletes a single certificate from the user's profile
class DeleteCertificateEvent extends ProfileEvent {
  final Certificate certificate;

  const DeleteCertificateEvent({required this.certificate});
}
