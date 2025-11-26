# Social

A Flutter package that provides easy-to-use social authentication with Google and phone number verification. The package includes a customizable sign-in UI with multiple authentication options.

## Features

- **Google Sign-In**: Authenticate users with their Google accounts
- **Phone Number Verification**: Verify users via OTP sent to their phone numbers
- **Customizable UI**: Fully customizable sign-in page with configurable colors and options
- **Skip Option**: Allow users to skip authentication if needed
- **Email Sign-In**: Placeholder for email authentication (to be implemented)
- **Responsive Design**: Works on different screen sizes
- **Error Handling**: Built-in error management and user feedback
- **Loading States**: Visual feedback during authentication processes

## Getting Started

### Prerequisites

Before using this package, you need to set up:

1. **Firebase Project**: Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/)
2. **Google Sign-In**: Configure Google Sign-In in Firebase Authentication
3. **Phone Authentication**: Set up phone authentication in Firebase Authentication
4. **Android Assets**: Add your app signature for OTP auto-fill (for Android)

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  social: ^0.0.1
```

Then run:
```bash
flutter pub get
```

### Configuration

To use Google Sign-In, you need to configure your project:

#### Android Setup
1. Add your SHA-1 fingerprint to your Firebase project
2. Download `google-services.json` and place it in `android/app/`

#### iOS Setup
1. Download `GoogleService-Info.plist` and add it to your iOS project in Xcode

## Usage

### Basic Usage

```dart
import 'package:social/social.dart';

// Show the social sign-in page
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => SocialSignInPage(
      onSignInSuccess: (AuthUserData user) {
        // Handle successful sign-in
        print('User signed in: ${user.name}');
        // Navigate to your main screen
      },
    ),
  ),
);
```

### Customization

The `SocialSignInPage` can be customized in many ways:

```dart
SocialSignInPage(
  // Customize the logo
  imagelogo: Image.asset(
    'assets/my_logo.png',
    width: 100,
    height: 100,
  ),
  // Enable/disable specific sign-in methods
  enableGoogle: true,
  enablePhone: true,
  enableEmail: false, // Email sign-in is currently not implemented
  enableSkip: true,
  // Customize button colors
  googleButtonColor: Colors.red,
  phoneButtonColor: Colors.blue,
  skipButtonColor: Colors.grey,
  // Handle successful sign-in
  onSignInSuccess: (AuthUserData user) {
    // Process the authenticated user
    print('UID: ${user.uid}');
    print('Name: ${user.name}');
    print('Email: ${user.email}');
  },
)
```

### Handling Authentication Data

After successful authentication, you'll receive an `AuthUserData` object with the following fields:

```dart
AuthUserData {
  String? uid,      // User ID from Firebase
  String? name,     // Display name
  String? email,    // Email address
  String? photoUrl, // Profile photo URL
  String? token,    // Authentication token
}
```

## Authentication Methods

### Google Sign-In
The package provides full Google Sign-In functionality with Firebase integration. 
- The user's name, email, and profile picture are retrieved from Google.
- All authentication is handled securely with Firebase.

### Phone Number Verification
The package provides a complete OTP verification flow:
1. User enters their phone number
2. OTP is sent to the phone number
3. User enters the OTP in the verification screen
4. Authentication is completed if OTP is valid

### Skip Authentication
Users can skip the authentication process if needed, which is useful for guest access.

## UI Components

### SocialButton
A reusable button component that can display either an icon or an asset image:

```dart
SocialButton(
  text: 'Continue with Google',
  color: Colors.red,
  assetIcon: 'assets/google-removebg-preview.png',  // Optional asset icon
  packageName: 'social',                           // Package name for asset loading
  icon: Icon(Icons.phone),                         // Optional material icon
  onPressed: () => _onSignIn('Google'),
)
```

**Note**: When using asset icons from this package, make sure to specify `packageName: 'social'` to ensure the assets load correctly.

### Assets
This package includes several social media icon assets:
- `assets/google-removebg-preview.png` - Google sign-in icon
- `assets/facebook-removebg-preview.png` - Facebook sign-in icon (not yet implemented)
- `assets/ig-removebg-preview.png` - Instagram sign-in icon (not yet implemented)
- `assets/mm.png` - Myanmar flag icon for phone input

## Error Handling

The package provides built-in error handling with user-friendly feedback:

- Loading dialogs during authentication processes
- Error messages via SnackBar
- Proper error handling for network failures
- Validation for user inputs

## Dependencies

This package uses the following dependencies:
- `firebase_auth`: For Firebase authentication
- `google_sign_in`: For Google Sign-In functionality
- `another_flushbar`: For displaying error messages
- `pin_code_fields`: For OTP input fields
- `otp_autofill`: For automatic OTP detection on Android
- `google_fonts`: For custom fonts

## Contributing

Contributions are welcome! Here's how you can contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please make sure to update tests as appropriate.

## License

This package is licensed under the BSD 3-Clause License. See the [LICENSE](LICENSE) file for more details.

## Support

If you encounter any issues or have questions, please file an issue in the repository. You can expect a response from the maintainers within a few days.