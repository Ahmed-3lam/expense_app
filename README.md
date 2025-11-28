# Expense Tracker Lite

A lightweight expense tracking mobile application built with Flutter that works offline, integrates with currency conversion API, supports pagination, and features a custom UI.

## 📱 Features

- ✅ **Dashboard Screen** with user profile, balance card, and expense list
- ✅ **Add Expense Screen** with category selection, amount input, and receipt upload
- ✅ **Currency Conversion** - Real-time conversion to USD using Open Exchange Rates API
- ✅ **Pagination** - Infinite scroll with 10 items per page
- ✅ **Local Storage** - Offline support using Hive database
- ✅ **Filtering** - Filter expenses by date range (This Month, Last 7 Days, Last 30 Days, All Time)
- ✅ **BLoC Pattern** - Clean architecture with separate BLoCs for each feature
- ✅ **Dependency Injection** - Automated DI using GetIt and Injectable
- ✅ **Custom UI** - Beautiful design matching the provided specifications

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns and feature-based organization:

```
lib/
├── config/                    # App configuration
├── core/                      # Shared utilities and constants
│   ├── constants/             # App colors, text styles, categories
│   ├── di/                    # Dependency Injection setup
│   ├── init/                  # Initialization logic
│   ├── utils/                 # Formatters and helpers
│   └── widgets/               # Reusable widgets
└── features/                  # Feature modules
    ├── currency/              # Currency feature
    │   ├── data/              # Data layer (Repositories, Data Sources, Models)
    │   ├── domain/            # Domain layer (Entities, Use Cases, Repository Interfaces)
    │   └── presentation/      # Presentation layer (BLoC, Screens, Widgets)
    ├── dashboard/             # Dashboard feature
    └── expense/               # Expense feature
```

### Layer Responsibilities

**Domain Layer (Inner Layer):**
- **Entities**: Pure Dart objects representing business concepts.
- **Use Cases**: Encapsulate specific business rules.
- **Repository Interfaces**: Define contracts for data operations.
- **Dependencies**: None (Pure Dart).

**Data Layer (Middle Layer):**
- **Models**: Data transfer objects (DTOs) with serialization logic (Hive/JSON).
- **Data Sources**: Handle raw data access (Local DB, Remote API).
- **Repositories**: Implement domain repository interfaces, coordinating data sources.
- **Dependencies**: Domain Layer.

**Presentation Layer (Outer Layer):**
- **BLoC**: Manages state and handles user events using Use Cases.
- **Screens**: UI pages.
- **Widgets**: Reusable UI components.
- **Dependencies**: Domain Layer.

## 🎯 State Management

This app uses **BLoC (Business Logic Component)** pattern with `flutter_bloc` package:

- **ExpenseBloc** - Handles expense operations (add, update, delete, filter, paginate)
- **CurrencyBloc** - Manages currency conversion and exchange rates
- **DashboardBloc** - Calculates totals and handles filter changes

Each BLoC follows the pattern:
- **Events** - User actions or system events
- **States** - UI states (loading, loaded, error)
- **BLoC** - Business logic that transforms events into states

## 💉 Dependency Injection

The app uses **GetIt** and **Injectable** for dependency injection:

- **Automated Generation**: `injectable_generator` creates the DI configuration.
- **Singleton Pattern**: Repositories and Data Sources are registered as singletons.
- **Factory Pattern**: BLoCs are registered as factories.
- **External Modules**: Third-party classes (like `Dio`) are registered via modules.

## 💾 Local Storage

Using **Hive** for fast, lightweight local storage:

- Expenses stored in `expenses` box
- Currency rates cached in `settings` box (24-hour cache)
- Type-safe with generated adapters
- Supports offline-first architecture

## 🌐 API Integration

**Currency Conversion API:**
- Base URL: `https://open.er-api.com/v6/latest/USD`
- Client: **Dio** for robust HTTP requests
- No API key required
- Supports 9 major currencies (USD, EUR, GBP, JPY, INR, AUD, CAD, CHF, CNY)
- Automatic caching to reduce API calls
- Fallback to cached data if API fails

**Conversion Flow:**
1. User enters amount in their preferred currency
2. App fetches latest exchange rates (or uses cache)
3. Amount is converted to USD for storage
4. Both original and USD amounts are displayed

## 📄 Pagination Strategy

**Local Pagination:**
- All expenses stored in Hive
- Paginated in-memory for performance
- Page size: 10 items
- Infinite scroll implementation
- Filter-aware pagination (filters apply before pagination)

**Implementation:**
```dart
// Load first page
context.read<ExpenseBloc>().add(LoadExpenses());

// Load more on scroll
context.read<ExpenseBloc>().add(LoadMoreExpenses());
```

## 🎨 UI Design

The app closely replicates the provided design with:

**Colors:**
- Primary Blue: `#2D5BFF`
- Background: `#F5F6FA`
- Income Green: `#00D09E`
- Expense Red: `#FF6B9D`

**Typography:**
- Font: Inter (Google Fonts)
- Headers: Bold, 28px
- Balance: Bold, 36px
- Body: Regular, 14-16px

**Components:**
- Gradient balance card with shadow
- Icon-based category selection
- Rounded cards with subtle shadows
- Floating action button for quick add

## 🧪 Testing

The project includes comprehensive tests:

**Unit Tests:**
- ✅ `expense_validation_test.dart` - Expense model validation
- ✅ `currency_calculation_test.dart` - Currency conversion logic
- ✅ `pagination_test.dart` - Pagination logic

Run tests:
```bash
flutter test
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.0 or higher)
- Dart SDK (3.8.0 or higher)
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. **Clone the repository:**
```bash
git clone <repository-url>
cd expense_app
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate code (Hive adapters & DI config):**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Run the app:**
```bash
flutter run
```

## 📱 How to Use

### Dashboard Screen
1. View your total balance, income, and expenses
2. Filter expenses by time period using the dropdown
3. Scroll to load more expenses (pagination)
4. Tap the + button to add a new expense

### Add Expense Screen
1. Select a category (Groceries, Entertainment, Transport, etc.)
2. Enter the amount and select currency
3. Pick a date
4. Optionally upload a receipt image
5. Tap "Save" to add the expense

The app will automatically:
- Convert the amount to USD
- Store both original and converted amounts
- Update the dashboard
- Navigate back to the dashboard

## 🔧 Configuration

### Supported Currencies
- USD (US Dollar)
- EUR (Euro)
- GBP (British Pound)
- JPY (Japanese Yen)
- INR (Indian Rupee)
- AUD (Australian Dollar)
- CAD (Canadian Dollar)
- CHF (Swiss Franc)
- CNY (Chinese Yuan)

### Categories
- Groceries 🛒
- Entertainment 🎮
- Gas ⛽
- Shopping 🛍️
- News Paper 📰
- Transport 🚗
- Rent 🏠

## 📊 Data Models

### Expense Model
```dart
{
  id: String,
  category: String,
  amount: double,
  currency: String,
  amountInUSD: double,
  date: DateTime,
  receiptPath: String?,
  createdAt: DateTime
}
```

### Currency Rate Model
```dart
{
  baseCurrency: String,
  rates: Map<String, double>,
  timestamp: DateTime
}
```

## 🎯 Trade-offs & Assumptions

**Trade-offs:**
1. **Local Pagination** - All data loaded from Hive, then paginated in-memory for simplicity
2. **Single User** - No authentication, designed for single-user use
3. **Local Receipt Storage** - Receipts stored as file paths, not uploaded to cloud
4. **24-hour Cache** - Exchange rates cached for 24 hours to reduce API calls

**Assumptions:**
1. User tracks expenses only (no income tracking)
2. All expenses are negative (outgoing money)
3. USD is the base currency for summaries
4. User has internet connection for first currency conversion (then works offline)

## 🐛 Known Issues

- None currently identified

## 🔮 Future Enhancements

- [ ] Income tracking
- [ ] Budget limits and alerts
- [ ] Expense analytics with charts
- [ ] Export to CSV/PDF
- [ ] Multi-user support with authentication
- [ ] Cloud sync
- [ ] Recurring expenses
- [ ] Categories customization
- [ ] Dark mode
- [ ] Localization

## 📦 Dependencies

**Core:**
- `flutter_bloc: ^8.1.6` - State management
- `equatable: ^2.0.5` - Value equality
- `hive: ^2.2.3` - Local database
- `hive_flutter: ^1.1.0` - Hive Flutter integration
- `dio: ^5.4.0` - HTTP client
- `get_it: ^8.0.2` - Service Locator
- `injectable: ^2.5.0` - Dependency Injection
- `intl: ^0.19.0` - Internationalization
- `uuid: ^4.5.1` - Unique ID generation
- `image_picker: ^1.1.2` - Image selection
- `google_fonts: ^6.2.1` - Custom fonts

**Dev Dependencies:**
- `hive_generator: ^2.0.1` - Code generation
- `build_runner: ^2.4.13` - Build system
- `injectable_generator: ^2.6.2` - DI code generation
- `bloc_test: ^9.1.7` - BLoC testing
- `mocktail: ^1.0.4` - Mocking

## 👨‍💻 Development

### Project Structure Best Practices
- Each feature has its own BLoC
- Repositories abstract data sources
- Models are immutable with Equatable
- Widgets are small and reusable
- Constants are centralized
- Dependency Injection for loose coupling

### Code Style
- Follow Flutter style guide
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused




