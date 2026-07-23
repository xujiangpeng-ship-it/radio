# Global Broadcast App - Build Script

This script helps build the Flutter APK.

## Prerequisites

1. Install Flutter SDK: https://docs.flutter.dev/get-starta/install/windows
2. Download Android Studio: https://developer.android.com/studio
3. Accept Android licenses: `flutter doctor --android-licenses`

## Build Commands

```powershell
# Navigate to client directory
cd radio/client

# Get dependencies
flutter pub get

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release
```

## Output

APK file will be at: `build/app/outputs/flutter-apk/app-release.apk`
