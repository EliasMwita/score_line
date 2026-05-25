# Repository Guidelines

## Project Structure & Module Organization

The project follows a standard Flutter structure with specific organization within the `lib/` directory:

- **`./lib/classes/`**: Contains domain models (e.g., `EplTeam`, `Event`, `Player`) and global state management via `AppState`.
- **`./lib/screens/`**: Houses all UI pages and complex components like `nav_bar.dart`.
- **`./lib/main.dart`**: The application entry point, which configures the `GoRouter` for navigation and initializes the `ChangeNotifierProvider` for global state.

## Build, Test, and Development Commands

Standard Flutter CLI commands are used for development:

- **Get dependencies**: `flutter pub get`
- **Run the app**: `flutter run`
- **Run all tests**: `flutter test`
- **Run a single test**: `flutter test test/widget_test.dart`
- **Static analysis**: `flutter analyze`

## Coding Style & Naming Conventions

The project adheres to the official Dart and Flutter linting rules defined in `./analysis_options.yaml`, which includes `package:flutter_lints/flutter.yaml`.

- **State Management**: Uses the `provider` package. Global state should be managed within `AppState` in `./lib/classes/app_state.dart`.
- **Navigation**: Uses the `go_router` package. Routes are defined in `./lib/main.dart`.
- **Naming**: Follows standard Dart PascalCase for classes and snake_case for file names (e.g., `home_page.dart`).

## Testing Guidelines

The test suite is located in the `./test/` directory.

- **Framework**: Uses `flutter_test` (built on `package:test`).
- **Tests**: Currently includes widget tests for verifying UI components. New features should include corresponding widget or unit tests in the `./test/` directory.

## Commit & Pull Request Guidelines

As the repository is in its initial stages, follow these general principles:

- **Commit Messages**: Use clear, descriptive messages (e.g., "feat: add team details screen", "fix: resolve overflow in nav bar").
- **Branching**: Use feature branches for new development and merge via pull requests.
