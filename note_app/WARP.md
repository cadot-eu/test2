# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Flutter/Dart application for note-taking with Markdown support. It's an Android-focused app that stores notes locally using SharedPreferences and provides real-time Markdown preview functionality.

**Key Technologies:**
- Flutter 3.13+ with Dart 3.0+
- Provider for state management
- SharedPreferences for local storage
- flutter_markdown for Markdown rendering
- Material Design UI components

## Essential Commands

### Development Setup
```bash
# Get dependencies
flutter pub get

# Run in development mode
flutter run

# Run on specific device
flutter run -d <device_id>

# Hot reload is automatic, force hot restart:
# Press 'R' in terminal or Ctrl+R in IDE
```

### Building
```bash
# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

### Testing and Quality
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/note_test.dart

# Code analysis (lint)
flutter analyze

# Format code
flutter format lib/ test/
```

### Development Workflow
```bash
# Clean build artifacts
flutter clean && flutter pub get

# Check available devices
flutter devices

# View logs
flutter logs
```

## Architecture Overview

### Core Architecture Pattern
- **State Management**: Provider pattern with ChangeNotifier
- **Data Layer**: Local persistence via SharedPreferences
- **UI Pattern**: StatefulWidget with Consumer widgets for reactive UI
- **Navigation**: Named routes with Material page transitions

### Key Components

**Data Flow:**
1. `NoteService` manages all note operations and persists to SharedPreferences
2. UI components consume `NoteService` via Provider's Consumer widgets
3. Changes notify listeners automatically, updating UI reactively

**File Structure:**
```
lib/
├── main.dart              # App entry point with Provider setup
├── models/
│   └── note.dart          # Note data model with JSON serialization
├── services/
│   └── note_service.dart  # Business logic and persistence layer
├── pages/
│   ├── splash_page.dart   # App launch screen
│   ├── home_page.dart     # Main note list with search
│   └── note_editor_page.dart # Note creation/editing with Markdown tabs
└── widgets/
    └── note_card.dart     # Reusable note display component
```

**State Management Pattern:**
- `NoteService` extends `ChangeNotifier` for reactive state
- UI widgets use `Consumer<NoteService>` to rebuild on changes
- All note operations are async and persist immediately to local storage

**Data Persistence:**
- Notes stored as JSON strings in SharedPreferences
- Automatic serialization/deserialization via Note model methods
- No network dependency - fully offline application

### Key Features Implementation

**Markdown Support:**
- Real-time preview using flutter_markdown package
- Tab-based editor (Edit/Preview) in note editor
- Supports standard Markdown syntax (headers, bold, italic, lists, links, code blocks)

**Search Functionality:**
- Real-time search across note titles and content
- Case-insensitive matching implemented in NoteService.searchNotes()
- Search UI integrated in AppBar with clear button

**Note Management:**
- CRUD operations: Create, Read, Update, Delete
- Automatic timestamp tracking (created/updated dates)
- Note duplication feature
- Export/import functionality for backup

## Development Guidelines

### Testing Strategy
- Unit tests focus on Note model serialization/deserialization
- Service tests cover CRUD operations and search functionality
- Use flutter_test framework with standard matchers

### Performance Considerations
- ListView.builder used for efficient large note list rendering
- Notes sorted by creation date (most recent first) for optimal UX
- Minimal rebuilds through targeted Consumer widgets

### UI/UX Patterns
- Material Design theming with consistent color scheme
- Animated transitions using AnimationController and Curves
- RefreshIndicator for pull-to-refresh functionality
- Proper keyboard navigation and focus management

### Error Handling
- Try-catch blocks around SharedPreferences operations
- Null-safe operations with proper fallbacks
- User-friendly error states and empty states

## Localization Notes
The app is currently French-localized. All user-facing strings are in French, including:
- UI labels and buttons
- Error messages and empty states
- Date formatting and relative time display

## Build Configuration
- Target Android API 21+ (Android 5.0)
- Uses Material Design components
- Automatic icon generation configured in pubspec.yaml
- GitHub Actions workflow for automated CI/CD builds

## Common Development Tasks

### Adding New Note Features
1. Extend Note model with new properties and update serialization methods
2. Update NoteService with corresponding business logic
3. Modify UI components to surface new functionality
4. Add tests for new functionality in note_test.dart

### Debugging Note Persistence
- Check SharedPreferences key consistency (`notes` key used throughout)
- Verify JSON serialization in Note.toJson()/fromJson() methods
- Use flutter logs to see SharedPreferences error messages

### Modifying UI Themes
- Update theme configuration in main.dart's MaterialApp
- Consistent use of Theme.of(context) for accessing colors
- Material Design color scheme defined in main.dart
