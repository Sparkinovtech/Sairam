enum Domains {
  graphicsDesigner,
  uiUxDesigner,
  webDeveloper,
  mobileApplicationDeveloper,
  architectureDesigner,
  machineLearning,
  promptEngineering,
  threeDModelDevelopment,
  arvrDevelopment,
  marketingManagement,
  rubyOnRails,
  others,
}

extension DomainName on Domains {
  String domainName(Domains domain) {
    switch (domain) {
      case Domains.graphicsDesigner:
        return "Graphics Designer";
      case Domains.uiUxDesigner:
        return "UI/UX Designer";
      case Domains.webDeveloper:
        return "Web Developer";
      case Domains.mobileApplicationDeveloper:
        return "Mobile Application Developer";
      case Domains.architectureDesigner:
        return "Architecture Designer";
      case Domains.machineLearning:
        return "Machine Learning";
      case Domains.promptEngineering:
        return "Prompt Engineering";
      case Domains.threeDModelDevelopment:
        return "3D Model Development";
      case Domains.arvrDevelopment:
        return "ARVR Development";
      case Domains.marketingManagement:
        return "Marketing Management";
      case Domains.rubyOnRails:
        return "Ruby On Rails";
      case Domains.others:
        return "Others";
    }
  }
}
