# JobTrack — Flutter Job Application Tracker

JobTrack helps job seekers record applications, track interview dates and statuses, and explore remote job listings from the Remotive API.

## Requirements
- Flutter SDK (Dart 3)
- Internet access for the live remote-jobs API section

## Run the application
```bash
flutter pub get
flutter analyze
flutter run
```

## Main features
- First-launch account creation with name, email, password, and password confirmation
- Login and logout; the local session is retained between app restarts
- Dashboard, application list, application details, add/edit/delete, and calendar
- Profile editing for name, email, phone, location, and target position
- Local persistence of application records, profile details, login session, and dark-mode preference using `shared_preferences`
- Dark theme with dark surfaces, readable text, themed inputs, cards, and navigation
- Remote job listings fetched from the Remotive API, including loading, error, retry, and empty states

## Notes
This coursework prototype stores account information locally on the device using SharedPreferences. It is suitable for demonstrating a local prototype, not as production-grade authentication. A production application should use a secure backend and password hashing. Application records and profile settings are stored on the same device and are not synchronized between devices.
