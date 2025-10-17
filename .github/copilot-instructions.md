# Copilot Instructions for Sairam Incubation

## Project Overview

Flutter mobile app for Sairam TAP (Technology Advancement Program) incubation center, managing student profiles, authentication, and incubation activities.

## Architecture

### State Management: BLoC Pattern

- **Two main BLoCs**: `AuthBloc` (authentication flow) and `ProfileBloc` (student profile management)
- **Global providers** in `main.dart` via `MultiBlocProvider` - these are app-wide singletons
- Use `BlocConsumer` for both listening to state changes AND rebuilding UI
- Use `BlocListener` when only side effects are needed (navigation, dialogs)
- Use `BlocBuilder` for UI-only state rebuilds

**Events naming**: `<Feature><Action>Event` (e.g., `AuthUserLogInEvent`, `RegisterProfileInformationEvent`)  
**States naming**: `<Feature><Status>State` (e.g., `LoggedInState`, `EditingProfileState`)

### Data Flow

```
User Action → Event → BLoC → Service/Provider → Backend (Firebase/Supabase) → Updated State → UI
```

### Backend Services

- **Firebase Auth** - Authentication (email/password only)
- **Cloud Firestore** - Student profile data storage (collection: `students`, doc ID: student ID from email)
- **Supabase Storage** - File storage (images, documents, resumes) with buckets: `files/{images,documents}`

### Provider Pattern

- Abstract `AuthenticationProvider` contract allows swapping auth backends
- `FirebaseAuthProvider` implements the contract
- `ProfileCloudFirestoreProvider` is a singleton (`shared`) with in-memory caching (`_studentProfile`)
- `SupabaseStorageProvider` handles file uploads/deletes with automatic cleanup of old files

## Critical Domain Rules

### Email Validation

**ALL emails MUST end with `@sairamtap.edu.in`** - validated in `FirebaseAuthProvider._validateEmail()`  
Student ID is derived from email: `email.split("@").first.toUpperCase()`

### Profile Creation Flow

1. User signs up → creates bare profile with ID + email only
2. On login, `AuthBloc.AuthInitialiseEvent` fetches or creates profile via `ProfileCloudFirestoreProvider`
3. Profile is cached in memory throughout the session

### File Upload Pattern (Critical!)

When updating profile fields with files (profile pic, resume, ID card, certificates):

1. Check if new file path differs from old URL
2. Extract storage path from old URL using `extractStoragePathFromUrl()` regex
3. Delete old file from Supabase before upload
4. Upload new file to appropriate folder (`images/` or `documents/`)
5. Save public URL to Firestore

**Example** in `ProfileBloc.RegisterProfileInformationEvent`:

```dart
if (previousPhotoUrl != null && profilePhotoUrl != previousPhotoUrl) {
  final oldPath = extractStoragePathFromUrl(previousPhotoUrl);
  if (oldPath != null) await storageProvider.deleteFile(oldPath);
}
```

## Key Conventions

### Network Handling

- `NetworkServices` provides real-time connectivity stream using `connectivity_plus`
- Global `NetworkDialog` singleton shows/hides network error dialog
- Stream subscription in `MyApp._MyAppState` monitors connectivity AFTER splash screen (`_isAfterSplash`)

### Loading States

- Global `LoadingScreen` singleton (shows overlay with Lottie animations)
- Always set `isLoading: true` before async operations, `false` after
- Loading text customized via state's `loadingText` property

### Navigation

- `navigatorKey` global in `main.dart` for dialog/navigation without BuildContext
- Auth flow uses state-driven navigation (states map to different pages in BlocConsumer builder)

### Model Serialization

- Models use `toJson()` / `fromJson()` for Firestore
- Enums stored as strings via `.name` / `values.byName()`
- `Profile` model uses `Equatable` for value comparison (important for BLoC state updates)

## Development Workflows

### Running the App

```bash
flutter pub get
flutter run
```

### Adding Dependencies

1. Add to `pubspec.yaml` dependencies section
2. Run `flutter pub get`
3. For Firebase: run FlutterFire CLI if needed

### Working with BLoC

When adding new features:

1. Define events in `*_event.dart` extending appropriate base
2. Define states in `*_state.dart`
3. Register event handlers in BLoC constructor using `on<EventType>()`
4. Emit loading state → perform async work → emit result/error state

### Profile Updates

Always use `ProfileCloudFirestoreProvider.save*()` methods which:

- Validate current profile exists (throw `UserProfileNotFoundException` if not)
- Create updated profile via `copyWith()`
- Save to Firestore AND update in-memory cache
- Return updated profile for state emission

## Testing Notes

- Test dependencies: `mockito`, `bloc_test`
- Test directory mirrors `lib/` structure
- Mock providers when testing BLoCs

## Common Pitfalls

- **Never bypass singleton providers** - always use `ProfileCloudFirestoreProvider.shared` or via BLoC
- **File cleanup required** - deleting old files before upload prevents storage bloat
- **Email domain enforcement** - all auth will fail for non-@sairamtap.edu.in emails
- **State loading flag** - forgetting to reset `isLoading: false` will freeze UI
- **Profile nullability** - always check `state.profile != null` before profile operations

## File Organization

```
lib/
├── Auth/              # Authentication (BLoC, views, services)
├── Profile/           # Student profile management (BLoC, views, services, models)
├── View/              # Main navigation and shared views (splash, bottom nav)
│   └── Components/    # Feature-specific pages (Home, profile details)
└── Utils/             # Shared utilities (dialogs, loaders, exceptions, calendar)
```

## Assets & UI

- Lottie animations in `assets/` for loading states, errors, success
- Google Fonts via `google_fonts` package
- Bottom navigation uses `google_nav_bar` package
- Profile uses `table_calendar` for calendar views
