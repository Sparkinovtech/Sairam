enum ScholarType { hosteller, dayScholar }

extension ScholarTypeExtension on ScholarType {
  String get displayName {
    switch (this) {
      case ScholarType.hosteller: return 'Hosteller';
      case ScholarType.dayScholar: return 'Day Scholar';
    }
  }

  static ScholarType? fromDisplayName(String? str) {
    switch (str) {
      case 'Hosteller': return ScholarType.hosteller;
      case 'Day Scholar': return ScholarType.dayScholar;
      default: return null;
    }
  }
}

// Usage:
// ScholarTypeExtension.fromDisplayName(json['scholarType']);
