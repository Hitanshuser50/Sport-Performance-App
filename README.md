# SportsMate

A comprehensive sports performance tracking application built with Flutter and Firebase.

## Features

- User Authentication (Email/Password and Google Sign-in)
- Game Management
- Player Performance Tracking
- Team Analytics
- Real-time Updates
- Dark/Light Theme Support

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Firebase Account
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Hitanshuser50/Sport-Performance-App.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Enable Authentication (Email/Password and Google Sign-in)
   - Set up Cloud Firestore
   - Download and add the Firebase configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS

4. Run the app:
```bash
flutter run
```

## Project Structure

```
/lib/
├── /screens/        # UI Screens
├── /components/     # Reusable widgets
├── /services/       # Firebase & API calls
├── /models/         # Data models
├── /providers/      # State management
├── /utils/          # Helper functions
└── main.dart        # Entry point
```

## Tech Stack

- Frontend: Flutter
- Backend: Firebase
- Database: Cloud Firestore
- Authentication: Firebase Auth
- State Management: Provider

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License.

