import 'package:flutter/foundation.dart';

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

  @override
  String toString() {
    return "Link Name : $linkName \n Link : $link";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Link && other.linkName == linkName && other.link == link;
  }

  @override
  int get hashCode => linkName.hashCode ^ link.hashCode;
}
