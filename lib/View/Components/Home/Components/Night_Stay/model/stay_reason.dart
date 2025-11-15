enum StayReason { adAstra, sparkIt, sih, incubationProject, softwareProject }

extension StayReasonExtension on StayReason {
  String get reasonName {
    switch (this) {
      case StayReason.adAstra:
        return "Ad Astra";
      case StayReason.sparkIt:
        return "Spark IT";
      case StayReason.sih:
        return "SIH";
      case StayReason.incubationProject:
        return "Incubation Project";
      case StayReason.softwareProject:
        return "Software Project";
    }
  }

  static StayReason fromMap(String stayReason) {
    switch (stayReason) {
      case "adAstra":
        return StayReason.adAstra;
      case "sparkIt":
        return StayReason.sparkIt;
      case "sih":
        return StayReason.sih;
      case "incubationProject":
        return StayReason.incubationProject;
      case "softwareProject":
        return StayReason.softwareProject;
      default:
        throw ArgumentError("Unknown stayReason: $stayReason");
    }
  }
}
