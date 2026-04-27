# Social Hub

Social Hub is a mini social network Flutter application.

## Features

- Email/password registration
- Login/logout
- Firebase Authentication
- Cloud Firestore posts
- Feed sorted by creation date
- Create posts
- Like posts
- Explore page with public API data using Dio
- SharedPreferences for username, theme, and language
- English, Russian, and Kazakh localization
- Light/dark theme
- Profile page
- Bottom navigation with 4 tabs

## Setup

Create a new Flutter project:

```bash
flutter create social_hub
```

Then copy these files into the created `social_hub` folder and replace existing files.

Install packages:

```bash
flutter pub get
```

Connect Firebase:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Enable in Firebase Console:

1. Authentication -> Email/Password
2. Cloud Firestore

Run:

```bash
flutter run
```

## Firestore collection

Collection name:

```text
posts
```

Fields:

```text
postId
userId
username
content
createdAt
likesCount
likedBy
```
