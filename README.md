# Student Management App

A Flutter app for managing student records, built as the final project for a Mobile Application Development course. Data is stored locally in SQLite, and the login session and theme preference are kept with SharedPreferences.

## Features

- **Login** with a session that persists between launches
- **Student records**: add, view, edit, and delete students (name, student ID, email, department)
- **Search** students by name
- **Delete confirmation** dialog to prevent accidental removal
- **Profile & Settings** screen with a dark mode switch that is remembered across restarts

## Tech stack

| Layer | Choice |
| --- | --- |
| Framework | Flutter (Dart SDK 3.11+) |
| Local database | SQLite via [`sqflite`](https://pub.dev/packages/sqflite) |
| Preferences | [`shared_preferences`](https://pub.dev/packages/shared_preferences) |
| UI | Material Design, light and dark themes |

## Project structure

```text
lib/
├── main.dart                  # App entry point, theme handling
├── database/db_helper.dart    # SQLite setup and CRUD queries
├── models/student_model.dart  # Student model with map conversion
├── screens/                   # Login, home, students list, add, edit, profile
└── widgets/                   # Student card, delete confirmation dialog
```

## Getting started

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install).

```bash
git clone https://github.com/eng-Ahmed2004/student-management-app.git
cd student-management-app
flutter pub get
flutter run
```

## Author

Ahmed Srour — [@eng-Ahmed2004](https://github.com/eng-Ahmed2004)
