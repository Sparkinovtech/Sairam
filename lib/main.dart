import 'dart:async';
import 'dart:developer' as devtools;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sairam_incubation/Auth/Service/firebase_auth_provider.dart';
import 'package:sairam_incubation/Auth/Service/network_service.dart';
import 'package:sairam_incubation/Auth/View/forget_page.dart';
import 'package:sairam_incubation/Auth/View/login_page.dart';
import 'package:sairam_incubation/Auth/View/signup_page.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/service/profile_cloud_firestore_provider.dart';
import 'package:sairam_incubation/Utils/Loader/loading_screen.dart';
import 'package:sairam_incubation/Utils/bottom_nav_bar.dart';
import 'package:sairam_incubation/Auth/View/verify_page.dart';
import 'package:sairam_incubation/Auth/bloc/auth_bloc.dart';
import 'package:sairam_incubation/Auth/bloc/auth_event.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';
import 'package:sairam_incubation/Utils/dialogs/network_dialog.dart';
import 'package:sairam_incubation/View/splash_screen.dart';
import 'package:sairam_incubation/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              FirebaseAuthProvider(),
              ProfileCloudFirestoreProvider(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(ProfileCloudFirestoreProvider()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
NetworkServices services = NetworkServices();
NetworkDialog dialog = NetworkDialog();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<bool> streamSubscription;
  @override
  void initState() {
    streamSubscription = services.connectionStream.listen((isConnected) {
      final context = navigatorKey.currentContext;

      if (context == null) return;
      if (!isConnected) {
        dialog.showNetworkDialog(context);
      } else {
        dialog.hide(context);
      }
    });
    context.read<AuthBloc>().add(AuthInitialiseEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isLoading) {
            LoadingScreen().show(
              context: context,
              text: state.loadingText ?? "Please Wait a moment...",
            );
          } else {
            LoadingScreen().hide();
          }
        },
        builder: (context, state) {
          devtools.log("From the Splash screen : $state");
          if (state is LoggedInState) {
            return BottomNavBar();
          } else if (state is LoggedOutState) {
            return LoginPage();
          } else if (state is ForgotPasswordState) {
            return ForgetPage();
          } else if (state is RequiresEmailVerifiactionState) {
            return VerifyEmailPage();
          } else if (state is RegisteringState) {
            return SignupPage();
          }
          return SplashScreen();
        },
      ),
    );
  }
}
