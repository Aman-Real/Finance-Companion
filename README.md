# Finance Companion

Finance Companion is a Flutter-based personal finance app built from the `lib` folder structure. It offers transaction tracking, goal management, spending insights, and theme-based settings using local persistence and state management.

## Key Features

- Transaction tracking with local storage powered by Hive
- Expense/income management in a clean, provider-managed app state
- Dark mode support via app settings
- Visual spending insights and charts using `fl_chart`
- Modular screen architecture for home, transactions, goals, profile, and analytics

## Project Structure

The main Flutter logic lives in `lib/` and is organized as follows:

- `lib/main.dart` - App entry point, initializes Hive, and configures providers
- `lib/core/` - Theme, shared utilities, and app-wide constants
- `lib/models/` - Data models including `TransactionModel` and generated Hive adapter
- `lib/providers/` - App state management with `FinanceProvider` and `SettingsProvider`
- `lib/screens/` - UI screens for home, add transaction, goals, insights, profile, and transactions
- `lib/services/` - Persistent data service for Hive storage
- `lib/widgets/` - Reusable components used throughout the app

## Dependencies

The app currently uses the following packages:

- `provider` for state management
- `hive` and `hive_flutter` for local data persistence
- `fl_chart` for charts and visual insights
- `intl` for date and currency formatting
- `flutter_svg` for scalable vector graphics support

## Setup and Run

1. Install Flutter if it is not already installed: https://flutter.dev/docs/get-started/install
2. Open the project folder:
   ```bash
   cd "c:/WORK/APP DEVELOPMENT/resume projects/financecompanion"
   ```
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app on an emulator or connected device:
   ```bash
   flutter run
   ```

## Notes

- Hive storage is initialized at startup in `lib/main.dart`.
- The app reads and writes transactions to a Hive box named `transactions`.
- Theme mode is controlled by `SettingsProvider`.

## Contributing

Feel free to extend the app with additional features like budgets, recurring payments, or export/import support.

---

Built with Flutter and designed for quick iteration on personal finance features.