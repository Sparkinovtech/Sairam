import 'dart:developer' as devtools;
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sairam_incubation/Profile/Model/link.dart';
import 'package:sairam_incubation/Profile/Model/profile.dart';
import 'package:sairam_incubation/Profile/bloc/profile_event.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Profile/service/profile_cloud_firestore_provider.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(ProfileCloudFirestoreProvider cloudProvider)
    : super(
        InitialProfileState(isLoading: false, profile: cloudProvider.profile),
      ) {
    on<RegisterProfileInformationEvent>((event, emit) async {
      emit(EditingProfileState(isLoading: true, profile: state.profile));
      try {
        final profile = await cloudProvider.saveProfileInformation(
          profilePic: event.profilePic,
          dateOfBirth: event.dateOfBirth,
          fullName: event.fullName,
          phoneNumber: event.phoneNumber,
          department: event.department,
          emailAddress: event.emailAddress,
        );
        emit(ProfileInformationDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(
          ProfileErrorState(
            errorMessage: e.toString(),
            isLoading: false,
            profile: state.profile,
          ),
        );
      }
    });

    on<RegisterIdentityDetailsEvent>((event, emit) async {
      emit(EditingIdentityDetailState(isLoading: true, profile: state.profile));
      try {
        final profile = await cloudProvider.saveIdentityDetails(
          studentId: event.studentId,
          department: event.department,
          currentYear: event.currentYear,
          yearOfGraduation: event.yearOfGraduation,
          mentorName: event.mentorName,
          idCardPhoto: event.idCardPhoto,
        );
        emit(IdentityDetailsDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(
          ProfileErrorState(
            errorMessage: e.toString(),
            isLoading: false,
            profile: state.profile,
          ),
        );
      }
    });

    on<RegisterWorkPreferencesEvent>((event, emit) async {
      emit(
        EditingWorkPreferencesState(isLoading: true, profile: state.profile),
      );
      try {
        final profile = await cloudProvider.saveDomainPreferences(
          event.domains ?? List.empty(),
        );
        emit(WorkPreferencesDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(
          ProfileErrorState(
            errorMessage: e.toString(),
            isLoading: false,
            profile: state.profile,
          ),
        );
      }
    });

    on<RegisterSkillSetEvent>((event, emit) async {
      emit(EditingSkillSetState(isLoading: true, profile: state.profile));
      try {
        final profile = await cloudProvider.saveSkillSet(
          skills: event.domains,
          resumeFile: event.resumeFile,
        );
        emit(SkillSetDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(
          ProfileErrorState(
            errorMessage: e.toString(),
            isLoading: false,
            profile: state.profile,
          ),
        );
      }
    });

    on<RegisterPortfolioEvent>((event, emit) async {
      emit(EditingPortfolioState(isLoading: true, profile: state.profile));
      try {
        final profile = await cloudProvider.savePortfolioLinks(
          links: event.links,
          mediaList: event.mediaList,
        );
        emit(PortfolioDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(
          ProfileErrorState(
            errorMessage: e.toString(),
            isLoading: false,
            profile: state.profile,
          ),
        );
      }
    });

    on<RegisterCertificateEvent>((event, emit) async {
      emit(EditingCertificatesState(isLoading: true, profile: state.profile));
      try {
        final profile = await cloudProvider.saveCertificates(
          certificates: event.certificates,
        );
        emit(CertificateDoneState(isLoading: false, profile: profile));
      } catch (e) {
        emit(
          ProfileErrorState(
            errorMessage: e.toString(),
            isLoading: false,
            profile: state.profile,
          ),
        );
      }
    });

    on<AddPortfolioLinkEvent>((event, emit) async {
      final currentProfile = state.profile;
      if (currentProfile == null) {
        emit(
          ProfileErrorState(
            errorMessage: "User Profile not found",
            isLoading: false,
            profile: null,
          ),
        );
        return;
      }
      try {
        emit(EditingPortfolioState(isLoading: true, profile: currentProfile));
        final updatedLinks = List<Link>.from(currentProfile.links ?? [])
          ..add(event.link);
        // Call your cloud storage method similar to RegisterPortfolioEvent
        final savedProfile = await cloudProvider.savePortfolioLinks(
          links: updatedLinks,
          mediaList: currentProfile.mediaList ?? [],
        );
        devtools.log(savedProfile.toString());
        emit(EditingPortfolioState(isLoading: false, profile: savedProfile));
      } catch (e) {
        emit(
          ProfileErrorState(
            errorMessage: e.toString(),
            isLoading: false,
            profile: state.profile,
          ),
        );
      }
    });

    on<DeletePortfolioLinkEvent>((event, emit) async {
      final currentProfile = state.profile;
      if (currentProfile == null) {
        emit(
          ProfileErrorState(
            errorMessage: "User Profile not found",
            isLoading: false,
            profile: null,
          ),
        );
        return;
      }

      try {
        emit(EditingPortfolioState(isLoading: true, profile: currentProfile));

        // Remove the target link (by identity; ensure Link implements == and hashCode)
        final updatedLinks = List<Link>.from(currentProfile.links ?? [])
          ..removeWhere((link) => link == event.link);

        currentProfile.copyWith(links: updatedLinks);

        // Save the updated profile (and media list) to your backend/cloud provider
        final savedProfile = await cloudProvider.savePortfolioLinks(
          links: updatedLinks,
          mediaList: currentProfile.mediaList ?? [],
        );

        emit(EditingPortfolioState(isLoading: false, profile: savedProfile));
      } catch (e) {
        emit(
          ProfileErrorState(
            errorMessage: e.toString(),
            isLoading: false,
            profile: state.profile,
          ),
        );
      }
    });
  }
}
