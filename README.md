# Cartify

Cartify is a Flutter e-commerce demo application that fetches products from the EscuelaJS fake API and displays them in a responsive product grid.

## Screenshots

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/c3da5fe6-17cf-40df-80c5-add9090ebf76" width="250"/></td>
    <td><img src="https://github.com/user-attachments/assets/e5dbe2f2-ea67-4a58-852a-73344d5782e0" width="250"/></td>
    <td><img src="https://github.com/user-attachments/assets/f8741749-19e4-4211-9cc0-93507e0ffef6" width="250"/></td>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/000218ff-44d4-4a95-8f85-13cb0af7f025" width="250"/></td>
    <td><img src="https://github.com/user-attachments/assets/a63abaf8-72cf-4e16-862f-596cd2146573" width="250"/></td>
    <td></td>
  </tr>
</table>

## Project Overview

### Core Features
- Splash screen with logo and smooth transition.
- Product listing screen with:
	- Product name
	- Product image
	- Product price
- Category filter chips fetched from API categories.
- Local category filtering after initial fetch (no API call on every tab switch).
- Loading skeleton effect while data is loading.
- Graceful error handling with user-friendly toast messages.
- Fallback logo placeholder when product image is missing or invalid.

### Architecture
The project uses a clean layered structure:

- Presentation Layer:
	- Screens and reusable UI widgets.
	- Provider state management.
- Data Layer:
	- API models.
	- Services for remote calls.
	- Repositories for data access abstraction.
- Infrastructure/Core:
	- Network manager (Dio-based).
	- Exception handling.
	- Dependency injection with GetIt.
	- Responsive utilities.

## API

The app uses the EscuelaJS fake API:

- Base URL: https://api.escuelajs.co/api/v1
- Products endpoint: /products
- Categories endpoint: /categories

## Steps To Run The Project

### Prerequisites
- Flutter SDK installed.
- Dart SDK (comes with Flutter).
- Android Studio / VS Code with Flutter extension.
- A connected device or emulator/simulator.

### Run Steps
1. Clone the repository.
2. Open the project folder.
3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

### Optional Useful Commands

```bash
flutter analyze
flutter test
```

## Additional Libraries / Packages Used

- provider: State management.
- get_it: Dependency injection / service locator.
- dio: HTTP client.
- pretty_dio_logger: API request/response logging.
- logger: Structured logging.
- internet_connection_checker: Network connectivity checks.
- skeletonizer: Loading skeleton UI.
- shared_preferences: Local key-value storage.
- sizer: Screen size helper.
- flutter_svg: SVG rendering support.

## Notes

- The app currently performs initial products + categories fetch once, then applies category filters locally for faster UX.
- Error messages shown to users are sanitized to generic friendly messages where needed.
