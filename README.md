# SYSTEMATES App - Setup and Installation Guide

Welcome to the SYSTEMATES application! This guide provides a comprehensive walkthrough for setting up, installing, and maintaining the project. It is designed to help developers quickly get started and ensure smooth future development.

---

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Project Structure](#project-structure)
4. [Firebase Configuration](#firebase-configuration)
    - [Removing Existing Configuration](#removing-existing-configuration)
    - [Setting Up Firebase](#setting-up-firebase)
5. [Adding Dependencies](#adding-dependencies)
6. [Configuring Android](#configuring-android)
7. [Running the Application](#running-the-application)
8. [Guidelines for Future Development](#guidelines-for-future-development)

---

## Introduction
This document provides a step-by-step guide to set up and install the Flutter application. It covers the project file structure, Firebase configuration, dependencies, and other critical aspects to aid in future development.

---

## Prerequisites
- **Flutter SDK**: Version 3.5.4 or higher.
- **Development Tools**: Android Studio or Visual Studio Code.
- **Dart**: Installed and configured.
- **Firebase Console Access**: For project configuration.
- **Git**: Installed for version control.

---

## Project Structure
The project is organized as follows:

```plaintext
SYSTEMATES
├── android
├── assets
├── build
├── ios
├── lib
│   ├── controller
│   │   ├── auth_controller.dart
│   │   ├── event_controller.dart
│   │   └── news_controller.dart
│   ├── model
│   ├── pages
│   │   ├── auth
│   │   │   ├── login.dart
│   │   │   └── signup.dart
│   │   ├── dashboard
│   │   │   ├── add_event.dart
│   │   │   ├── add_news.dart
│   │   │   ├── detail_event.dart
│   │   │   ├── detail_news.dart
│   │   │   ├── edit_event.dart
│   │   │   ├── edit_news.dart
│   │   │   ├── event.dart
│   │   │   ├── home.dart
│   │   │   ├── profile.dart
│   │   │   └── scannerpage.dart
│   │   └── splashscreen
│   ├── firebase_options.dart
│   └── main.dart
├── linux
├── macos
```

## Firebase Configuration
### Removing Existing Configuration
1. Open the project in VS Code or any editor of your choice.
2. Navigate to the android/app/ folder.
3. Delete the google-services.json file if it exists.
### Setting Up Firebase
#### Firebase Console
1. Go to Firebase Console.
2. Click Add Project and create a new project (e.g., sipilku-1d50e).
3. Enable the following Firebase products:
    - Authentication: Enable Email/Password sign-in.
    - Firestore Database: Create a database in Test Mode.
#### Configure Firebase in the Flutter Project
1. Install FlutterFire CLI:
    ```bash
    dart pub global activate flutterfire_cli
    ```
2. Navigate to the root directory of your Flutter project.
    Run the following command:
    ```bash
    flutterfire configure --project=sipilku-1d50e
    ```
3. This will generate a firebase_options.dart file in the lib folder.

## Adding Dependencies
Open the pubspec.yaml file and ensure the following dependencies are added:

``` bash 
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.4
  cloud_firestore: ^5.5.1
  firebase_storage: ^12.3.7
  qr_flutter: ^4.1.0
  mobile_scanner: ^5.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
```

Run the following command to fetch the dependencies:

```bash
flutter pub get
```

## Configuring Android
#### Update android/build.gradle
Add the Firebase classpath under dependencies:

```bash
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

### Update android/app/build.gradle
Add the Firebase plugin at the bottom of the file:

```bash 
apply plugin: 'com.google.gms.google-services'
```

## Running the Application
1. Connect a device or start an emulator.
2. Run the following command in the terminal:
```bash
flutter run
```
3. Ensure the app launches successfully.

## Guidelines for Future Development
1. File Organization: Keep controllers, models, and views in their respective folders for clarity.
2. Version Control: Use Git to track changes. Commit frequently with descriptive messages.
3. Dependency Updates: Regularly update dependencies in pubspec.yaml to keep the project secure and up-to-date.

## Conclusion
This document serves as a comprehensive guide for setting up and maintaining the Flutter project. Following these steps ensures a smooth workflow and streamlined development process.

```bash

---

### How It Works:
- The `[Link Text](#section-heading)` format ensures auto-scrolling.
- For example, `[Back to Top](#systemates-app---setup-and-installation-guide)` links to the title of the document.
- Replace spaces with `-` and convert headings to lowercase to create valid anchors.

Let me know if you want this saved or if you need additional guidance!

```