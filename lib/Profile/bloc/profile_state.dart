import 'package:sairam_incubation/Profile/Model/profile.dart';

/// Represents the different states of the profile editing process.
abstract class ProfileState {
  final Profile? profile;

  /// Indicates whether a process is ongoing.
  final bool isLoading;

  /// A message to display while loading.
  final String? loadingText;

  const ProfileState({
    required this.isLoading,
    this.loadingText = "Please wait a moment...",
    required this.profile,
  });
}

/// The initial state of the profile page before any operations begin.
class InitialProfileState extends ProfileState {
  InitialProfileState({required super.isLoading, required super.profile});
}

/// State indicating that the main profile information is being edited.
class EditingProfileState extends ProfileState {
  EditingProfileState({required super.isLoading, required super.profile});
}

/// State indicating that the identity details are being edited.
class EditingIdentityDetailState extends ProfileState {
  EditingIdentityDetailState({
    required super.isLoading,
    required super.profile,
  });
}

/// State indicating that the skill set is being edited.
class EditingSkillSetState extends ProfileState {
  EditingSkillSetState({required super.isLoading, required super.profile});
}

/// State indicating that the portfolio is being edited.
class EditingPortfolioState extends ProfileState {
  EditingPortfolioState({required super.isLoading, required super.profile});
}

/// State indicating that the certificates are being edited.
class EditingCertificatesState extends ProfileState {
  EditingCertificatesState({required super.isLoading, required super.profile});
}

/// State indicating that work preferences are being edited.
class EditingWorkPreferencesState extends ProfileState {
  EditingWorkPreferencesState({
    required super.isLoading,
    required super.profile,
  });
}

/// State indicating that the profile information has been successfully saved.
class ProfileInformationDoneState extends ProfileState {
  ProfileInformationDoneState({
    required super.isLoading,
    required super.profile,
  });
}

/// State indicating that the identity details have been successfully saved.
class IdentityDetailsDoneState extends ProfileState {
  IdentityDetailsDoneState({required super.isLoading, required super.profile});
}

/// State indicating that the work preferences have been successfully saved.
class WorkPreferencesDoneState extends ProfileState {
  WorkPreferencesDoneState({required super.isLoading, required super.profile});
}

/// State indicating that the skill set has been successfully saved.
class SkillSetDoneState extends ProfileState {
  SkillSetDoneState({required super.isLoading, required super.profile});
}

/// State indicating that the portfolio has been successfully saved.
class PortfolioDoneState extends ProfileState {
  PortfolioDoneState({required super.isLoading, required super.profile});
}

/// State indicating that the certificates have been successfully saved.
class CertificateDoneState extends ProfileState {
  CertificateDoneState({required super.isLoading, required super.profile});
}

/// State indicating that an error has occurred during a profile operation.
class ProfileErrorState extends ProfileState {
  final String errorMessage;

  ProfileErrorState({
    required this.errorMessage,
    required super.isLoading,
    required super.profile,
  });
}
