import 'package:flutter/material.dart';

@immutable
class Certificate {
  final String certificateName;
  final String expirationTime;
  final String certificateLink;

  const Certificate({
    required this.certificateName,
    required this.expirationTime,
    required this.certificateLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'certificateName': certificateName,
      'expirationTime': expirationTime,
      'certificateLink': certificateLink,
    };
  }

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      certificateName: json['certificateName'] as String,
      expirationTime: json['expirationTime'] as String,
      certificateLink: json['certificateLink'] as String,
    );
  }
}
