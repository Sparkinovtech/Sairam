import 'package:flutter/material.dart';

@immutable
class Certificate {
  final String cetificateName;
  final String expirationTime;
  final String certificateLink;

  const Certificate({
    required this.cetificateName,
    required this.expirationTime,
    required this.certificateLink,
  });
}
