import 'package:flutter/material.dart';

@immutable
class Link {
  final String linkName;
  final String link;

  const Link({required this.linkName, required this.link});

  Map<String, dynamic> toJson() {
    return {'linkName': linkName, 'link': link};
  }

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      linkName: json['linkName'] as String,
      link: json['link'] as String,
    );
  }
}
