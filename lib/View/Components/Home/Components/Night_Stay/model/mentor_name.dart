enum MentorName {
  jayandanSA,
  samAustinJ,
  leninS,
  muthuvelA,
  raghulD,
  dhanush,
  startup,
}

extension MentorNameExtension on MentorName {
  String get mentor {
    switch (this) {
      case MentorName.jayandanSA:
        return "Jayandan S A";
      case MentorName.samAustinJ:
        return "Sam Austin J";
      case MentorName.leninS:
        return "Lenin S";
      case MentorName.muthuvelA:
        return "Muthuvel A";
      case MentorName.raghulD:
        return "Raghul D";
      case MentorName.dhanush:
        return "Dhanush";
      case MentorName.startup:
        return "Startup";
    }
  }

  static MentorName fromMap(String name) {
    switch (name) {
      case "jayandanSA":
        return MentorName.jayandanSA;
      case "samAustinJ":
        return MentorName.samAustinJ;
      case "leninS":
        return MentorName.leninS;
      case "muthuvelA":
        return MentorName.muthuvelA;
      case "raghulD":
        return MentorName.raghulD;
      case "dhanush":
        return MentorName.dhanush;
      case "startup":
        return MentorName.startup;
      default:
        throw ArgumentError("Unknown mentor name: $name");
    }
  }
}
