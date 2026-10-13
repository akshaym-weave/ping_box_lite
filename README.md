# Flutter inbox interview — 3–5 years of experience

A 60-minute coding round: fix four bugs, make the list lazy, and add three tests as a separate task.
Read [QUESTIONS.md](QUESTIONS.md) for the required behavior and timing.
The starter intentionally fails analysis until Q1. Async loading, parsing, layout,
and selected-conversation read behavior need fixes. The skipped tests are placeholders, not passing evidence.

## System requirements before participating

Complete setup before the interview. Setup time is excluded from the 60-minute round.

| Item | What to prepare |
| --- | --- |
| Computer | A Windows, macOS, or Linux laptop/desktop supported by your Flutter SDK, with permission to install tools and write project files. |
| Memory and storage | For this round, we recommend at least 8 GB RAM and 10 GB free disk space; 16 GB RAM is preferable if using an emulator. These are practical interview recommendations, not official Flutter minimums. |
| Flutter and Dart | Flutter stable on your terminal `PATH`, with bundled Dart >=3.3 and <4.0. This kit was validated with Flutter 3.38.5 / Dart 3.10.4. Use the interviewer's agreed SDK version. |
| Editor | VS Code with Flutter/Dart extensions, Android Studio with Flutter/Dart plugins, or another editor you can use comfortably. |
| Run target | Google Chrome installed and detected by `flutter devices`. Chrome is sufficient for the round; a configured Android/iOS device is an alternative. |
| Git | Git installed and available in the terminal for Flutter setup and any repository checkout. |
| Internet | Available for SDK installation and initial dependency resolution. For a remote interview, also confirm the call and screen sharing work. The demo app runs offline. |

Follow the official [Flutter installation guide](https://docs.flutter.dev/install/manual)
and [editor setup guide](https://docs.flutter.dev/install/with-vs-code) if needed.
Flutter includes Dart; a separate Dart installation is unnecessary.

### Pre-interview readiness checklist

Run these commands from the extracted `candidate/` folder:

```sh
flutter --version
git --version
flutter doctor -v
flutter devices
flutter pub get
flutter analyze
```

Before the round, confirm:

- Flutter commands work and the SDK matches the version agreed with the interviewer.
- `flutter doctor -v` shows a working Flutter installation and Chrome is listed in
  `flutter devices`. Android/iOS/desktop toolchain warnings do not block a Chrome-only round.
- `flutter pub get` completes successfully, and the project opens in your editor.
- `flutter analyze` reports the intentional type error in `lib/inbox_controller.dart`.
  This is part of Q1, not a setup failure. The starter cannot launch until it is fixed
  during the round; do not repair the exercise in advance.
- You have read [QUESTIONS.md](QUESTIONS.md) and confirmed the AI-assistance policy
  with the interviewer. Report setup problems before the scheduled round.

To verify that Flutter can actually launch in Chrome before the interview, use a
separate sample project **outside the candidate folder**:

```sh
flutter create --platforms=web inbox_setup_check
cd inbox_setup_check
flutter run -d chrome
```

This sample should open in Chrome. Keep it separate from your interview submission.
No third-party packages, backend, credentials, or external assets are needed for this kit.

### Optional mobile setup

Use mobile only if you already have a working environment or the interviewer requests it.
Android requires its SDK/toolchain and an emulator or connected device. iOS requires
macOS, Xcode, and a simulator or configured device. Python 3 is needed only for the
supplied mobile-host setup helper:

```sh
python3 tool/setup_mobile.py
flutter devices
flutter run -d <device-id>
```

On Windows, use `py tool/setup_mobile.py`. Run the helper before timing starts;
launch the interview app after fixing Q1. A mobile emulator or physical device is
not required when using Chrome.

## Check scenarios

Stop and restart the app when changing defines:

```sh
# Q1: default is 30 conversations
flutter run -d chrome
flutter run -d chrome --dart-define=THREAD_COUNT=0
flutter run -d chrome --dart-define=FAIL_FIRST=true
# Q2: larger list
flutter run -d chrome --dart-define=THREAD_COUNT=500
# Q3: after replacing skipped placeholders
flutter test
```

## Structure

- `lib/main.dart`: inbox layout, search, rows, and preview screen.
- `lib/inbox_controller.dart`: loading, search, and unread state.
- `lib/thread.dart`: supplied model and JSON adapter.
- `lib/repository.dart`: supplied offline fixture and injectable interface.
- `test/exercise_test.dart`: two logic and one widget test placeholders.
- `PERFORMANCE.md`: short manual before/after observations.

The preview screen shows only the latest message. Keep changes small and explainable.
