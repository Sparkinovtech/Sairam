import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_event.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Profile/service/profile_cloud_firestore_provider.dart';

/// A BLoC (Business Logic Component) for managing the user's profile.
///
/// This BLoC handles events related to creating and updating a user's profile,
/// which is divided into several sections:
/// - Profile Information
/// - Identity Details
/// - Work Preferences
/// - Skill Set
/// - Portfolio
/// - Certificates
///
/// It receives [ProfileEvent]s and transforms them into [ProfileState]s.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  /// Initializes the BLoC with an initial [InitialProfileState].
  ProfileBloc(ProfileCloudFirestoreProvider cloudProvider)
    : super(
        InitialProfileState(isLoading: false, profile: cloudProvider.profile),
      ) {
    // Register event handlers for each profile-related event.

    /// Handles the [RegisterProfileInformationEvent].
    ///
    /// This event is triggered when the user submits their basic profile information.
    /// It emits an [EditingProfileState] to indicate that the profile is being updated,
    /// then (in a real application) it would call a service to save the data.
    /// Finally, it emits a [ProfileInformationDoneState] upon successful completion.
    on<RegisterProfileInformationEvent>((event, emit) async {
      emit(EditingProfileState(isLoading: true, profile: null));
      try {
        final profile = await cloudProvider.saveProfileInformation(
          profilePic: event.profilePic,
          dateOfBirth: event.dateOfBirth,
          fullName: event.fullName,
          phoneNumber: event.phoneNumber,
          department: event.department,
          emailAddress: event.emailAddress,
        );
        // Example:,
        // await _profileServiceProvider.saveProfileInformation(
        //   profilePic: event.profilePic,
        //   fullName: event.fullName,
        //   emailAddress: event.emailAddress,
        //   phoneNumber: event.phoneNumber,
        //   department: event.department,
        //   dateOfBirth: event.dateOfBirth,
        // );
        emit(ProfileInformationDoneState(isLoading: false, profile: profile));
      } catch (e) {
        // In case of an error, you might want to emit a specific error state.
        emit(InitialProfileState(isLoading: false, profile: null));
      }
    });

    /// Handles the [RegisterIdentityDetailsEvent].
    ///
    /// This event is triggered when the user submits their identity details.
    /// It emits an [EditingIdentityDetailState] while processing the data,
    /// and a [IdentityDetailsDoneState] upon success.
    on<RegisterIdentityDetailsEvent>((event, emit) async {
      emit(EditingIdentityDetailState(isLoading: true, profile: null));
      try {
        final profile = await cloudProvider.saveIdentityDetails(
          studentId: event.studentId,
          department: event.department,
          currentYear: event.currentYear,
          yearOfGraduation: event.yearOfGraduation,
          mentorName: event.mentorName,
          idCardPhoto: event.idCardPhoto,
        );
        // Example:
        // await _profileServiceProvider.saveIdentityDetails(
        //   studentId: event.studentId,
        //   department: event.department,
        //   currentYear: event.currentYear,
        //   yearOfGraduation: event.yearOfGraduation,
        //   mentorName: event.mentorName,
        //   idCardPhoto: event.idCardPhoto,
        // );
        emit(IdentityDetailsDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(InitialProfileState(isLoading: false, profile: null));
      }
    });

    /// Handles the [RegisterWorkPreferencesEvent].
    ///
    /// This event is triggered when the user selects their work preferences (domains).
    /// It emits an [EditingWorkPreferencesState] during processing and a
    /// [WorkPreferencesDoneState] when the data is saved.
    on<RegisterWorkPreferencesEvent>((event, emit) async {
      emit(EditingWorkPreferencesState(isLoading: true, profile: null));
      try {
        final profile = await cloudProvider.saveDomainPreferences(
          event.domains ?? List.empty(),
        );
        // Example:
        // await _profileServiceProvider.saveWorkPreferences(
        //   domains: event.domains,
        // );
        emit(WorkPreferencesDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(InitialProfileState(isLoading: false, profile: null));
      }
    });

    /// Handles the [RegisterSkillSetEvent].
    ///
    /// Triggered when the user submits their skills and resume.
    /// Emits [EditingSkillSetState] and [SkillSetDoneState] to reflect the state.
    on<RegisterSkillSetEvent>((event, emit) async {
      emit(EditingSkillSetState(isLoading: true, profile: null));
      try {
        final profile = await cloudProvider.saveSkillSet(
          skills: event.domains,
          resumeFile: event.resumeFile,
        );
        // Example:
        // await _profileServiceProvider.saveSkillSet(
        //   domains: event.domains,
        //   resumeFile: event.resumeFile,
        // );
        emit(SkillSetDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(InitialProfileState(isLoading: false, profile: null));
      }
    });

    /// Handles the [RegisterPortfolioEvent].
    ///
    /// Triggered when the user adds links to their portfolio.
    /// Emits [EditingPortfolioState] and [PortfolioDoneState] to manage the state.
    on<RegisterPortfolioEvent>((event, emit) async {
      emit(EditingPortfolioState(isLoading: true, profile: null));
      try {
        final profile = await cloudProvider.savePortfolioLinks(
          links: event.links,
        );
        // Example:
        // await _profileServiceProvider.savePortfolio(
        //   links: event.links,
        // );
        emit(PortfolioDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(InitialProfileState(isLoading: false, profile: null));
      }
    });

    /// Handles the [RegisterCertificateEvent].
    ///
    /// Triggered when the user uploads their certificates.
    /// Emits [EditingCertificatesState] and [CertificateDoneState] to show progress.
    on<RegisterCertificateEvent>((event, emit) async {
      emit(EditingCertificatesState(isLoading: true, profile: null));
      try {
        final profile = await cloudProvider.saveCertificates(
          certificates: event.certificates,
        );
        // Example:
        // await _profileServiceProvider.saveCertificates(
        //   certificates: event.certificates,
        // );
        emit(CertificateDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(InitialProfileState(isLoading: false, profile: null));
      }
    });
  }
}
