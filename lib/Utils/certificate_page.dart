import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sairam_incubation/Utils/Loader/loading_screen.dart';

import 'package:sairam_incubation/Utils/add_certificates.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/bloc/profile_event.dart';
import 'package:sairam_incubation/Profile/bloc/profile_state.dart';
import 'package:sairam_incubation/Profile/Model/certificate.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
      Permission.mediaLibrary,
    ].request();
  }

  Future<void> _navigateToAddCertificate() async {
    await _requestPermissions();
    final result = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: const AddCertificates(hintText: "mm/yyyy"),
      ),
    );
    if (result is Certificate) {
      context.read<ProfileBloc>().add(
        // Add the new certificate to the list
        AddCertificateEvent(certificate: result),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.isLoading) {
          // Show loading overlay
          LoadingScreen().show(context: context, text: "Loading");
        } else {
          LoadingScreen().hide();
        }

        if (state is CertificateDoneState) {
          // On success, pop back (or refresh UI as needed)
          Navigator.of(context).pop();
        }

        if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
          );
        }
      },
      builder: (context, state) {
        final certificates = state.profile?.certificates ?? [];

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Earned Certificates",
                        style: GoogleFonts.lato(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add documents or photos (.jpg / .pdf)",
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: certificates.isEmpty
                      ? Center(
                          child: Text(
                            'No certificates added yet.',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: certificates.length,
                          itemBuilder: (context, index) {
                            final cert = certificates[index];
                            return _certificateCard(
                              context,
                              cert,
                              onEdit: () async {
                                // Navigate to edit certificate page
                                final edited =
                                    await Navigator.push<Certificate>(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: AddCertificates(hintText: ""),
                                      ),
                                    );
                                if (edited != null) {
                                  context.read<ProfileBloc>().add(
                                    UpdateCertificateEvent(
                                      oldCertificate: cert,
                                      newCertificate: edited,
                                    ),
                                  );
                                }
                              },
                              onDelete: () {
                                context.read<ProfileBloc>().add(
                                  DeleteCertificateEvent(certificate: cert),
                                );
                              },
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ).copyWith(bottom: 30, top: 10),
                  child: MaterialButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.blue),
                    ),
                    elevation: 0,
                    onPressed: _navigateToAddCertificate,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Add Certificate',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _certificateCard(
    BuildContext context,
    Certificate certificate, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    var size = MediaQuery.of(context).size;

    final filePath = certificate.certificateLink;
    bool isNetworkUrl = filePath.startsWith('http');

    ImageProvider imageProvider;
    if (filePath.isNotEmpty) {
      if (isNetworkUrl) {
        imageProvider = NetworkImage(filePath);
      } else {
        imageProvider = FileImage(File(filePath));
      }
    } else {
      // Fallback placeholder image
      imageProvider = const AssetImage('assets/images/default_certificate.png');
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                image: imageProvider,
                width: size.width * 0.15,
                height: size.width * 0.15,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: size.width * 0.15,
                  height: size.width * 0.15,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    certificate.certificateName.isNotEmpty
                        ? certificate.certificateName
                        : 'Untitled',
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (certificate.expirationTime.isNotEmpty)
                    Text(
                      'Expires: ${certificate.expirationTime}',
                      style: GoogleFonts.lato(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, color: Colors.grey),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
