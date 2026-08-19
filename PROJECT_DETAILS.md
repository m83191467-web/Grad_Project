# G Project - App Documentation

## 1. Project Overview
This project is a Flutter mobile application named `g_project` with:
- Firebase Authentication
- Firebase Firestore
- Google Sign-In
- Google Maps integration
- Phone number login flow
- Passenger app UI

The app currently includes login, OTP verification, Google sign-in, and passenger map screens.

---

## 2. App Structure

### Root folders
- `android/` — Android native configuration
- `ios/` — iOS project files
- `assets/` — static local assets
- `lib/` — Flutter application source code
- `test/` — test files

### Main app folders
- `lib/main.dart` — app entry point
- `lib/di/injection.dart` — dependency injection setup
- `lib/screens/` — UI screens
- `lib/features/` — feature-based app logic
- `lib/models/` — app models
- `lib/providers/` — app providers

---

## 3. Main App Entry
File: `lib/main.dart`

Responsibilities:
- Initializes Firebase
- Initializes dependency injection
- Starts the app with `NavioApp`
- Provides `AuthBloc` at the top of the app

Current app configuration:
- `MaterialApp`
- `debugShowCheckedModeBanner: false`
- `theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.black))`

---

## 4. Application Theme and Colors
The app currently uses a minimal color system built around black and white.

### Main colors used in the app
- Black: `Colors.black`
- White: `Colors.white`
- Light gray: `const Color(0xffF5F5F5)`
- Gray text: `Colors.grey`
- Border gray: `Colors.black12`

### Visual style
- Flat black-and-white color scheme
- Material 3 design
- Rounded card inputs and containers
- Buttons with black fill and white text
- Outlined Google button on white background

### Example UI colors
- App bars: black background, white foreground
- Buttons: black background, white text
- Screen backgrounds: white or light gray
- Text: black or gray

---

## 5. Screens

### 1. Splash Screen
File: `lib/screens/splash_screen.dart`

Responsibilities:
- Shows the application logo
- Animates the logo for a short period
- Redirects based on authentication state

Logic:
- If user is authenticated → `PassengerScreen`
- Else → `UserTypeScreen`

---

### 2. Login Screen
File: `lib/screens/login_screen.dart`

Responsibilities:
- Phone number login
- Country selection
- OTP request flow
- Google sign-in flow
- Navigation to registration and passenger flows

Features:
- Country picker with Sudan and Egypt in favorites
- Phone input
- OTP request trigger
- Google sign button
- Real Firebase Google sign-in flow via `GoogleSignIn` + `FirebaseAuth`

Main UI areas:
- App logo at top
- Arabic login text
- Country selector + phone number field
- Send OTP button
- Divider text: `أو`
- Google sign-in button
- Register / forgot password text buttons

---

### 3. OTP Screen
File: `lib/screens/otp_screen.dart`

Responsibilities:
- Accept the SMS verification code
- Submit the OTP using `AuthBloc`
- Navigate to passenger screen upon successful authentication

---

### 4. Passenger Screen
File: `lib/screens/passenger_screen.dart`

Responsibilities:
- Main passenger dashboard
- Drawer navigation
- Search destination example
- Map area

Current UI layout:
- AppBar with title `Navio`
- Notification icon
- Drawer with sections for profile, trips, payment, settings, logout
- Text fields and map area in body

---

### 5. Map Screen
File: `lib/screens/map_screen.dart`

Responsibilities:
- Loads a Google Map view
- Applies map state from `MapBloc`

Current behavior:
- Shows a centered map in a `GoogleMap` widget
- Uses `myLocationEnabled` and `myLocationButtonEnabled`
- Displays a map marker at a default location in Khartoum

---

### 6. User Type Screen
File: `lib/screens/user_type_screen.dart`

Responsibilities:
- Allows choosing user type
- Start flow for user onboarding or login

---

### 7. Register Screen
File: `lib/screens/register_screen.dart`

Responsibilities:
- New account registration UI
- Collects user name and phone number

---

---

## 6. Authentication Architecture

### Firebase auth usage
The project uses Firebase Authentication and Firebase Firestore.

Relevant files:
- `lib/features/auth/data/repositories/auth_repository_impl.dart`
- `lib/features/auth/data/datasources/auth_remote_datasource.dart`
- `lib/features/auth/presentation/bloc/auth_bloc.dart`
- `lib/features/auth/presentation/bloc/auth_event.dart`
- `lib/features/auth/presentation/bloc/auth_state.dart`

### Auth flow
1. User logs in with phone number or Google
2. Firebase Auth handles the identity
3. User data is stored in Firestore
4. Auth state is emitted through `AuthBloc`
5. UI redirects based on auth state

---

## 7. Firebase Configuration
Files involved:
- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `google-services.json` in the project root or app directory

Project setup includes:
- Firebase Core initialization
- Firebase Auth
- Firestore
- Google Sign-In provider support

### Firebase requirements for real functionality
- Firebase project created
- Android app connected to Firebase
- `google-services.json` correctly placed
- Google Sign-In enabled in Firebase Console
- correct SHA1 fingerprint added for Android

---

## 8. Google Sign-In Implementation
The app uses real Firebase Google sign-in via:
- `google_sign_in` package
- `FirebaseAuth.instance.signInWithCredential(...)`

The app button in `LoginScreen` performs a real authentication flow and not a simulated placeholder flow.

---

## 9. Google Maps Implementation
The app uses the real Google Maps Flutter plugin:
- `google_maps_flutter`

The Android manifest includes the required metadata:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE" />
```

This placeholder must be replaced with a real Google Maps API key from Google Cloud Console.

---

## 10. Dependency Injection
File: `lib/di/injection.dart`

The app registers:
- `AuthRemoteDataSource`
- `AuthRepository`
- `AuthBloc`
- user-related repositories/use cases

This keeps the app design structured and modular.

---

## 11. Current Dependency List
Key dependencies in `pubspec.yaml` include:
- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `google_sign_in`
- `google_maps_flutter`
- `geolocator`
- `flutter_bloc`
- `bloc`
- `get_it`
- `country_picker`
- `equatable`
- `provider`
- `intl`
- `shared_preferences`

---

## 12. App Logic Summary
### Current working features
- Firebase app initialization
- Google login flow
- Phone number login screen UI
- OTP screen UI
- Passenger dashboard screen
- Google map screen with marker and map state

### Current setup requirements
- Valid Firebase config
- Google provider enabled in Firebase
- Google Maps API key added to Android manifest
- Valid SHA1 for Android signing

---

## 13. Known Important Notes
- Do not leave the Google Maps API key as `YOUR_API_KEY_HERE`.
- Firebase Phone Auth may require billing enabled in Firebase Console.
- Google sign-in must be enabled in the Firebase Console before it works on device.
- For Android emulator, local backend URLs may require `10.0.2.2` if a local API is used.

---

## 14. Recommended Next Improvements
- Add real user profile data from Firestore
- Add logout logic with Firebase signOut
- Add real navigation and ride booking logic
- Add real map location tracking with `geolocator`
- Add real Google Places search
- Add database-driven user roles and rider/driver flows

---

## 15. Final Status
The project is structured as a real Flutter Firebase app and includes real Google login and Google Maps integrations. The remaining items are project configuration tasks in Firebase and Google Cloud rather than dummy app logic.
