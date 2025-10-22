import 'dart:async';
import 'dart:developer' as devtools;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sairam_incubation/Auth/Service/firebase_auth_provider.dart';
import 'package:sairam_incubation/Auth/Service/network_service.dart';
import 'package:sairam_incubation/Auth/View/forget_page.dart';
import 'package:sairam_incubation/Auth/View/login_page.dart';
import 'package:sairam_incubation/Auth/View/signup_page.dart';
import 'package:sairam_incubation/Profile/bloc/profile_bloc.dart';
import 'package:sairam_incubation/Profile/service/profile_cloud_firestore_provider.dart';
import 'package:sairam_incubation/Profile/service/supabase_storage_provider.dart';
import 'package:sairam_incubation/Utils/Loader/loading_screen.dart';
import 'package:sairam_incubation/View/Components/Home/Components/Incubation_Components/bloc/component_bloc.dart';
import 'package:sairam_incubation/View/bottom_nav_bar.dart';
import 'package:sairam_incubation/Auth/View/verify_page.dart';
import 'package:sairam_incubation/Auth/bloc/auth_bloc.dart';
import 'package:sairam_incubation/Auth/bloc/auth_event.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';
import 'package:sairam_incubation/Utils/dialogs/network_dialog.dart';
import 'package:sairam_incubation/View/splash_screen.dart';
import 'package:sairam_incubation/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

const supabaseUrl = 'https://uytnwdzvyjvcozequeci.supabase.co';
const supabaseKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV5dG53ZHp2eWp2Y296ZXF1ZWNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM5NzQyNTAsImV4cCI6MjA2OTU1MDI1MH0.Su3HW6VXa07aiNXBNdOdDciuFQORvkBCZQdVg37fjbM";
Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(
                FirebaseAuthProvider(),
                ProfileCloudFirestoreProvider(),
              ),
            ),
            BlocProvider(
              create: (context) => ProfileBloc(
                ProfileCloudFirestoreProvider(),
                SupabaseStorageProvider(
                  supabase: SupabaseClient(supabaseUrl, supabaseKey),
                  bucketName: "files",
                ),
              ),
            ),
            BlocProvider(
              create: (context) =>
                  ComponentBloc(ProfileCloudFirestoreProvider()),

            ),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      devtools.log("Uncaught error: $error\n$stackTrace");
    },
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
  bool _isAfterSplash = false;
  late StreamSubscription<bool> streamSubscription;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthInitialiseEvent());
    });

    streamSubscription = services.connectionStream.listen((isConnected) {
      final context = navigatorKey.currentContext;

      if (context == null) return;
      if (!isConnected && _isAfterSplash) {
        if (!context.mounted) return;
        dialog.showNetworkDialog(context);
      } else {
        if (!context.mounted) return;
        dialog.hide(context);
      }
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.system,
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   primarySwatch: Colors.blue,
      //   // customize more if needed
      // ),
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

          if (state is! AuthInitialiseState) {
            _isAfterSplash = true;
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
