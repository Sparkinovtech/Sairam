import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sairam_incubation/Auth/Model/auth_user.dart';
import 'package:sairam_incubation/Auth/Service/authentication_provider.dart';
import 'package:sairam_incubation/Auth/bloc/auth_bloc.dart';
import 'package:sairam_incubation/Auth/bloc/auth_event.dart';
import 'package:sairam_incubation/Auth/bloc/auth_state.dart';
import 'package:sairam_incubation/Profile/Model/profile.dart';
import 'package:sairam_incubation/Profile/Model/scholar_type.dart';
import 'package:sairam_incubation/Profile/service/profile_cloud_firestore_provider.dart';

// Run `flutter pub run build_runner build` to generate this file.
@GenerateMocks([AuthenticationProvider, ProfileCloudFirestoreProvider])
import 'auth_test.mocks.dart';

import 'package:sairam_incubation/Profile/Model/department.dart';

// Create a dummy Profile:
// You can customize fields as needed for your test scenario.
final dummyProfile = Profile(
  id: 'u123',
  name: 'Test User',
  emailAddress: 'a@sairamtap.edu.in', // fix typo if you want in your model
  scholarType: ScholarType.hosteller, // Use an appropriate enum value
  department: Department.cse, // Use an example department enum
  phoneNumber: '1234567890',
  dateOfBirth: '1995-01-01',
  yearOfGraduation: 2023,
  currentYear: 4,
  resume: 'https://example.com/resume.pdf',
  currentMentor: 'Mentor Name',
  collegeIdPhoto: 'https://example.com/id_photo.jpg',
  domains: null,
  skillSet: null,
  mediaList: null,
  links: null,
  certificates: null,
);

void main() {
  group('AuthUser Model', () {
    test('creates AuthUser from Firebase User equivalents', () {
      final user = AuthUser(
        email: "test@sairamtap.edu.in",
        userId: "123",
        isEmailVerified: true,
      );
      expect(user.email, "test@sairamtap.edu.in");
      expect(user.userId, "123");
      expect(user.isEmailVerified, isTrue);
    });
  });

  group('AuthBloc Tests', () {
    late MockAuthenticationProvider mockProvider;
    late MockProfileCloudFirestoreProvider mockCloud;

    setUp(() {
      mockProvider = MockAuthenticationProvider();
      mockCloud = MockProfileCloudFirestoreProvider();
    });

    test('initial state is AuthStateUninitialized', () {
      final bloc = AuthBloc(mockProvider, mockCloud);
      expect(bloc.state, isA<AuthStateUninitialized>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits LoggedOutState when no user found on initialise',
      build: () {
        when(mockProvider.initialise()).thenAnswer((_) async => {});
        when(mockProvider.user).thenReturn(null);
        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) => bloc.add(AuthInitialiseEvent()),
      expect: () => [
        isA<LoggedOutState>().having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits LoggedInState when verified user exists on initialise with mock profile',
      build: () {
        final user = AuthUser(
          email: 'a@sairamtap.edu.in',
          userId: 'u123',
          isEmailVerified: true,
        );

        final mockProfile = Profile(
          id: user.userId,
          name: 'Test User',
          scholarType: ScholarType.hosteller,
          emailAddress: user.email,
        );

        when(mockProvider.initialise()).thenAnswer((_) async => {});
        when(mockProvider.user).thenReturn(user);
        when(
          mockCloud.getProfile(user: user),
        ).thenAnswer((_) async => mockProfile);

        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) => bloc.add(AuthInitialiseEvent()),
      expect: () => [
        isA<LoggedInState>()
            .having((state) => state.user.userId, 'userId', 'u123')
            .having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits RequiresEmailVerifiactionState when user email not verified',
      build: () {
        final user = AuthUser(
          email: 'a@sairamtap.edu.in',
          userId: 'u123',
          isEmailVerified: false,
        );
        when(mockProvider.initialise()).thenAnswer((_) async => {});
        when(mockProvider.user).thenReturn(user);
        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) => bloc.add(AuthInitialiseEvent()),
      expect: () => [
        isA<RequiresEmailVerifiactionState>().having(
          (s) => s.isLoading,
          'isLoading',
          false,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login success with verified email transitions to LoggedInState',
      build: () {
        final user = AuthUser(
          email: 'a@sairamtap.edu.in',
          userId: 'u123',
          isEmailVerified: true,
        );
        when(
          mockProvider.login(
            emailId: anyNamed('emailId'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => user);
        when(mockCloud.getProfile(user: user)).thenAnswer(
          (_) async => Profile(
            id: user.userId,
            name: 'Test User',
            scholarType: ScholarType.hosteller,
            emailAddress: user.email,
          ),
        );
        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) => bloc.add(
        AuthUserLogInEvent(email: 'a@sairamtap.edu.in', password: 'password'),
      ),
      expect: () => [
        isA<LoggedOutState>().having((s) => s.isLoading, 'isLoading', true),
        isA<LoggedOutState>().having((s) => s.isLoading, 'isLoading', false),
        isA<LoggedInState>().having(
          (state) => state.user.email,
          'email',
          'a@sairamtap.edu.in',
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login with unverified email emits RequiresEmailVerifiactionState',
      build: () {
        final user = AuthUser(
          email: 'a@sairamtap.edu.in',
          userId: 'u123',
          isEmailVerified: false,
        );
        when(
          mockProvider.login(
            emailId: anyNamed('emailId'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => user);
        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) => bloc.add(
        AuthUserLogInEvent(email: 'a@sairamtap.edu.in', password: 'password'),
      ),
      expect: () => [
        isA<LoggedOutState>().having((s) => s.isLoading, 'isLoading', true),
        isA<LoggedOutState>().having((s) => s.isLoading, 'isLoading', false),
        isA<RequiresEmailVerifiactionState>(),
      ],
    );

    // Additional Tests:

    blocTest<AuthBloc, AuthState>(
      'logout success emits LoggedOutState with no exception',
      build: () {
        when(mockProvider.logout()).thenAnswer((_) async => {});
        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) => bloc.add(AuthUserLogOutEvent()),
      expect: () => [
        isA<LoggedOutState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.exception, 'exception', null),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'logout failure emits LoggedOutState with exception',
      build: () {
        when(mockProvider.logout()).thenThrow(Exception('Logout Error'));
        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) => bloc.add(AuthUserLogOutEvent()),
      expect: () => [
        isA<LoggedOutState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.exception, 'exception', isException),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'registration success emits RequiresEmailVerifiactionState',
      build: () {
        final user = AuthUser(
          email: 'a@sairamtap.edu.in',
          userId: 'u123',
          isEmailVerified: false,
        );
        when(
          mockProvider.signup(
            emailId: anyNamed('emailId'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => user);
        when(
          mockCloud.createNewProfile(user: anyNamed('user')),
        ).thenAnswer((_) async => dummyProfile);
        when(mockProvider.sendEmailVerification()).thenAnswer((_) async => {});
        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) => bloc.add(
        AuthUserRegisterEvent(
          email: 'a@sairamtap.edu.in',
          password: 'password',
        ),
      ),
      expect: () => [
        isA<RegisteringState>()
            .having((s) => s.isLoading, 'isLoading', true)
            .having((s) => s.exception, 'exception', null),
        isA<RequiresEmailVerifiactionState>().having(
          (s) => s.isLoading,
          'isLoading',
          false,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'registration failure emits RegisteringState with exception',
      build: () {
        when(
          mockProvider.signup(
            emailId: anyNamed('emailId'),
            password: anyNamed('password'),
          ),
        ).thenThrow(Exception('Registration Error'));
        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) => bloc.add(
        AuthUserRegisterEvent(
          email: 'a@sairamtap.edu.in',
          password: 'password',
        ),
      ),
      expect: () => [
        isA<RegisteringState>().having((s) => s.isLoading, 'isLoading', true),
        isA<RegisteringState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.exception, 'exception', isException),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'password reset success emits LoggedOutState with no exception',
      build: () {
        when(
          mockProvider.resetPassword(email: anyNamed('email')),
        ).thenAnswer((_) async => {});
        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) =>
          bloc.add(AuthForgotPasswordEvent(email: 'a@sairamtap.edu.in')),
      expect: () => [
        isA<LoggedOutState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.exception, 'exception', null),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'password reset failure emits ForgotPasswordState',
      build: () {
        when(
          mockProvider.resetPassword(email: anyNamed('email')),
        ).thenThrow(Exception('Reset Error'));
        return AuthBloc(mockProvider, mockCloud);
      },
      act: (bloc) =>
          bloc.add(AuthForgotPasswordEvent(email: 'a@sairamtap.edu.in')),
      expect: () => [
        isA<ForgotPasswordState>().having(
          (s) => s.isLoading,
          'isLoading',
          false,
        ),
      ],
    );
  });
}
