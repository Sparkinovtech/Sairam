abstract class ProfileState {
  final bool isLoading;
  final String? loadingText;

  const ProfileState({
    required this.isLoading,
    this.loadingText = "Please Wait a moment...",
  });
}

class InitialeProfileState extends ProfileState {
  InitialeProfileState({required super.isLoading});
}

class EditingProfileState extends ProfileState {
  EditingProfileState({required super.isLoading});
}

class EditingIdentityDetailState extends ProfileState {
  EditingIdentityDetailState({required super.isLoading});
}

class EditingSkillSetState extends ProfileState {
  EditingSkillSetState({required super.isLoading});
}

class EditingPortfolioState extends ProfileState {
  EditingPortfolioState({required super.isLoading});
}

class EditingCertificatesState extends ProfileState {
  EditingCertificatesState({required super.isLoading});
}
