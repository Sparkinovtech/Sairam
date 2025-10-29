import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sairam_incubation/Profile/Model/link.dart';
import 'package:sairam_incubation/Profile/Model/media_items.dart';
import 'package:sairam_incubation/Profile/bloc/profile_event.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Profile/service/profile_cloud_firestore_provider.dart';
import 'package:sairam_incubation/Profile/service/supabase_storage_provider.dart';
import 'package:sairam_incubation/Profile/Model/certificate.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Night_Stay/service/night_stay_provider.dart';

String? extractStoragePathFromUrl(String url) {
  final regExp = RegExp(r'/storage/v1/object/public/[\w\-]+/(.*)$');
  final match = regExp.firstMatch(url);
  return match?.group(1);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileCloudFirestoreProvider cloudProvider;
  final SupabaseStorageProvider storageProvider;

  ProfileBloc(this.cloudProvider, this.storageProvider)
    : super(
        InitialProfileState(isLoading: false, profile: cloudProvider.profile),
      ) {
    // --- Profile Information (Profile Pic) ---
    on<RegisterProfileInformationEvent>((event, emit) async {
      emit(EditingProfileState(isLoading: true, profile: state.profile));
      try {
        String? profilePhotoUrl = event.profilePic;
        String? previousPhotoUrl = state.profile?.profilePicture;

        // Delete previous photo if new one given & not same
        if (previousPhotoUrl != null &&
            previousPhotoUrl.isNotEmpty &&
            profilePhotoUrl != previousPhotoUrl) {
          final oldPath = extractStoragePathFromUrl(previousPhotoUrl);
          if (oldPath != null) await storageProvider.deleteFile(oldPath);
        }

        // Upload new photo if local path
        if (profilePhotoUrl != null && File(profilePhotoUrl).existsSync()) {
          final uploadedPath = await storageProvider.uploadFile(
            "images",
            File(profilePhotoUrl),
          );
          if (uploadedPath != null) {
            profilePhotoUrl = storageProvider.getPublicUrl(uploadedPath);
          } else {
            throw Exception("Failed to upload new profile picture.");
          }
        }

        final profile = await cloudProvider.saveProfileInformation(
          profilePic: profilePhotoUrl,
          dateOfBirth: event.dateOfBirth,
          fullName: event.fullName,
          scholarType: event.scholarType,
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

    // --- Identity Details (ID Card) ---
    on<RegisterIdentityDetailsEvent>((event, emit) async {
      emit(EditingIdentityDetailState(isLoading: true, profile: state.profile));
      try {
        String? idCardUrl = event.idCardPhoto;
        String? previousIdCardUrl = state.profile?.collegeIdPhoto;

        if (previousIdCardUrl != null &&
            previousIdCardUrl.isNotEmpty &&
            idCardUrl != previousIdCardUrl) {
          final oldPath = extractStoragePathFromUrl(previousIdCardUrl);
          if (oldPath != null) await storageProvider.deleteFile(oldPath);
        }

        if (idCardUrl.isNotEmpty && File(idCardUrl).existsSync()) {
          final uploadedPath = await storageProvider.uploadFile(
            "documents",
            File(idCardUrl),
          );
          if (uploadedPath != null) {
            idCardUrl = storageProvider.getPublicUrl(uploadedPath);
          } else {
            throw Exception("Failed to upload new ID card.");
          }
        }

        final profile = await cloudProvider.saveIdentityDetails(
          studentId: event.studentId,
          department: event.department,
          currentYear: event.currentYear,
          yearOfGraduation: event.yearOfGraduation,
          mentorName: event.mentorName,
          idCardPhoto: idCardUrl,
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

    // --- Work Preferences ---
    on<RegisterWorkPreferencesEvent>((event, emit) async {
      emit(
        EditingWorkPreferencesState(isLoading: true, profile: state.profile),
      );
      try {
        final profile = await cloudProvider.saveDomainPreferences(
          event.domains ?? [],
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

    // --- SkillSet (Resume) ---
    on<RegisterSkillSetEvent>((event, emit) async {
      emit(EditingSkillSetState(isLoading: true, profile: state.profile));
      try {
        String? resumeUrl = event.resumeFile;
        String? previousResumeUrl = state.profile?.resume;

        if (previousResumeUrl != null &&
            previousResumeUrl.isNotEmpty &&
            resumeUrl != previousResumeUrl) {
          final oldPath = extractStoragePathFromUrl(previousResumeUrl);
          if (oldPath != null) await storageProvider.deleteFile(oldPath);
        }

        if (resumeUrl.isNotEmpty && File(resumeUrl).existsSync()) {
          final uploadedPath = await storageProvider.uploadFile(
            "documents",
            File(resumeUrl),
          );
          if (uploadedPath != null) {
            resumeUrl = storageProvider.getPublicUrl(uploadedPath);
          } else {
            throw Exception("Failed to upload resume.");
          }
        }

        final profile = await cloudProvider.saveSkillSet(
          skills: event.domains,
          resumeFile: resumeUrl,
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

    // --- Portfolio (Links & Media List) ---
    on<RegisterPortfolioEvent>((event, emit) async {
      emit(EditingPortfolioState(isLoading: true, profile: state.profile));
      try {
        final List<MediaItems> uploadedMediaList = [];
        for (final media in event.mediaList) {
          String? storagePath;
          if (media.file.path.isNotEmpty &&
              File(media.file.path).existsSync()) {
            storagePath = await storageProvider.uploadFile(
              "images",
              media.file,
            );
          }
          final url = storagePath != null
              ? storageProvider.getPublicUrl(storagePath)
              : media.file.path;
          uploadedMediaList.add(
            MediaItems(
              title: media.title,
              description: media.description,
              file: File(url),
            ),
          );
        }
        final profile = await cloudProvider.savePortfolioLinks(
          links: event.links,
          mediaList: uploadedMediaList,
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

    // --- Certificates (delete/upload if link is a file path) ---
    on<RegisterCertificateEvent>((event, emit) async {
      emit(EditingCertificatesState(isLoading: true, profile: state.profile));
      try {
        final List<Certificate> updatedCertificates = [];
        for (final cert in event.certificates) {
          String certUrl = cert.certificateLink;
          if (certUrl.isNotEmpty && File(certUrl).existsSync()) {
            final uploadPath = await storageProvider.uploadFile(
              "documents",
              File(certUrl),
            );
            certUrl = uploadPath != null
                ? storageProvider.getPublicUrl(uploadPath)
                : cert.certificateLink;
          }
          updatedCertificates.add(
            Certificate(
              certificateName: cert.certificateName,
              expirationTime: cert.expirationTime,
              certificateLink: certUrl,
            ),
          );
        }
        final profile = await cloudProvider.saveCertificates(
          certificates: updatedCertificates,
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

    // --- Portfolio Link Add & Delete ---
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
        final updatedLinks = List<Link>.from(currentProfile.links ?? [])
          ..removeWhere((link) => link == event.link);
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

    // --- Portfolio Media Add, Delete, and Update ---
    on<AddPortfolioMediaEvent>((event, emit) async {
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
        String url = event.mediaItem.file.path;
        if (url.isNotEmpty && File(url).existsSync()) {
          final uploadedPath = await storageProvider.uploadFile(
            "images",
            event.mediaItem.file,
          );
          url = uploadedPath != null
              ? storageProvider.getPublicUrl(uploadedPath)
              : url;
        }
        final List<MediaItems> updatedMedia = List<MediaItems>.from(
          currentProfile.mediaList ?? [],
        );
        updatedMedia.add(
          MediaItems(
            title: event.mediaItem.title,
            description: event.mediaItem.description,
            file: File(url),
          ),
        );
        final savedProfile = await cloudProvider.savePortfolioLinks(
          links: currentProfile.links ?? [],
          mediaList: updatedMedia,
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

    on<DeletePortfolioMediaEvent>((event, emit) async {
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
        final List<MediaItems> updatedMedia = List<MediaItems>.from(
          currentProfile.mediaList ?? [],
        );
        updatedMedia.removeWhere(
          (media) =>
              media.title == event.mediaItem.title &&
              media.file.path == event.mediaItem.file.path,
        );
        final savedProfile = await cloudProvider.savePortfolioLinks(
          links: currentProfile.links ?? [],
          mediaList: updatedMedia,
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

    on<UpdatePortfolioMediaEvent>((event, emit) async {
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
        String url = event.mediaItem.file.path;
        if (url.isNotEmpty && File(url).existsSync()) {
          final uploadedPath = await storageProvider.uploadFile(
            "images",
            event.mediaItem.file,
          );
          url = uploadedPath != null
              ? storageProvider.getPublicUrl(uploadedPath)
              : url;
        }
        final List<MediaItems> updatedMedia = List<MediaItems>.from(
          currentProfile.mediaList ?? [],
        );
        final idx = updatedMedia.indexWhere(
          (m) => m.title == event.mediaItem.title,
        );
        if (idx != -1) {
          updatedMedia[idx] = MediaItems(
            title: event.mediaItem.title,
            description: event.mediaItem.description,
            file: File(url),
          );
        }
        final savedProfile = await cloudProvider.savePortfolioLinks(
          links: currentProfile.links ?? [],
          mediaList: updatedMedia,
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

    // --- Add Certificate ---
    on<AddCertificateEvent>((event, emit) async {
      emit(EditingCertificatesState(isLoading: true, profile: state.profile));
      try {
        final currentCertificates = List<Certificate>.from(
          state.profile?.certificates ?? [],
        );

        String certUrl = event.certificate.certificateLink;

        // Upload new file if local path exists
        if (certUrl.isNotEmpty && File(certUrl).existsSync()) {
          final uploadPath = await storageProvider.uploadFile(
            "documents",
            File(certUrl),
          );
          if (uploadPath != null) {
            certUrl = storageProvider.getPublicUrl(uploadPath);
          } else {
            throw Exception("Failed to upload certificate file.");
          }
        }

        final newCert = Certificate(
          certificateName: event.certificate.certificateName,
          expirationTime: event.certificate.expirationTime,
          certificateLink: certUrl,
        );

        currentCertificates.add(newCert);

        final profile = await cloudProvider.saveCertificates(
          certificates: currentCertificates,
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

    // --- Update Certificate ---
    on<UpdateCertificateEvent>((event, emit) async {
      emit(EditingCertificatesState(isLoading: true, profile: state.profile));
      try {
        final currentCertificates = List<Certificate>.from(
          state.profile?.certificates ?? [],
        );

        // Remove old certificate by matching all fields or a unique identifier (implement as per your model)
        currentCertificates.removeWhere(
          (cert) =>
              cert.certificateName == event.oldCertificate.certificateName &&
              cert.expirationTime == event.oldCertificate.expirationTime &&
              cert.certificateLink == event.oldCertificate.certificateLink,
        );

        String certUrl = event.newCertificate.certificateLink;

        // Upload file if local
        if (certUrl.isNotEmpty && File(certUrl).existsSync()) {
          final uploadPath = await storageProvider.uploadFile(
            "documents",
            File(certUrl),
          );
          if (uploadPath != null) {
            certUrl = storageProvider.getPublicUrl(uploadPath);
          } else {
            throw Exception("Failed to upload updated certificate file.");
          }
        }

        final updatedCert = Certificate(
          certificateName: event.newCertificate.certificateName,
          expirationTime: event.newCertificate.expirationTime,
          certificateLink: certUrl,
        );

        currentCertificates.add(updatedCert);

        final profile = await cloudProvider.saveCertificates(
          certificates: currentCertificates,
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

    // --- Delete Certificate ---
    on<DeleteCertificateEvent>((event, emit) async {
      emit(EditingCertificatesState(isLoading: true, profile: state.profile));
      try {
        final currentCertificates = List<Certificate>.from(
          state.profile?.certificates ?? [],
        );

        currentCertificates.removeWhere(
          (cert) =>
              cert.certificateName == event.certificate.certificateName &&
              cert.expirationTime == event.certificate.expirationTime &&
              cert.certificateLink == event.certificate.certificateLink,
        );

        final profile = await cloudProvider.saveCertificates(
          certificates: currentCertificates,
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

    // --- Night Stay Button Click ---
    on<NightStayBtnClickEvent>((event, emit) async {
      final currentProfile = state.profile;
      emit(
        NightStayBtnClickState(
          nightStayStudent: event.nightStayStudent,
          isLoading: false,
          profile: currentProfile,
        ),
      );
    });
    // --- Check Night Stay Status ---
    final NightStayProvider _provider = NightStayProvider();
    on<CheckNightStayStatusProfileEvent>((event, emit) async {
      try {
        final hasOpted = await _provider.hasOptedForNightStay(event.studentId);
        emit(
          ProfileStatusState(
            hasOpted: hasOpted,
            isLoading: false,
            profile: state.profile,
          ),
        );
      } catch (e) {}
    });
  }
}
