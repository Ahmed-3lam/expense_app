---
description: Expense Tracker Lite Implementation Plan
---

# Expense Tracker Lite - Implementation Plan

## Project Overview
Building a Flutter expense tracking app with BLoC pattern, currency conversion, pagination, and custom UI matching the provided design.

## Architecture
- **State Management**: BLoC pattern (flutter_bloc) - using Bloc (not Cubit)
- **Local Storage**: Hive for offline persistence
- **API Integration**: Open Exchange Rates API for currency conversion
- **UI**: Custom design matching provided screenshots

## Project Structure
```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── category_icons.dart
│   ├── utils/
│   │   ├── date_formatter.dart
│   │   └── currency_formatter.dart
│   └── widgets/
│       └── custom_button.dart
├── data/
│   ├── models/
│   │   ├── expense_model.dart
│   │   └── currency_rate_model.dart
│   ├── repositories/
│   │   ├── expense_repository.dart
│   │   └── currency_repository.dart
│   └── datasources/
│       ├── local/
│       │   └── hive_database.dart
│       └── remote/
│           └── currency_api_service.dart
├── blocs/
│   ├── expense/
│   │   ├── expense_bloc.dart
│   │   ├── expense_event.dart
│   │   └── expense_state.dart
│   ├── currency/
│   │   ├── currency_bloc.dart
│   │   ├── currency_event.dart
│   │   └── currency_state.dart
│   └── dashboard/
│       ├── dashboard_bloc.dart
│       ├── dashboard_event.dart
│       └── dashboard_state.dart
└── presentation/
    ├── screens/
    │   ├── dashboard_screen.dart
    │   └── add_expense_screen.dart
    └── widgets/
        ├── balance_card.dart
        ├── expense_list_item.dart
        ├── category_selector.dart
        └── filter_dropdown.dart
```

## Implementation Steps

### Phase 1: Setup & Dependencies
1. ✅ Update pubspec.yaml with required dependencies
2. ✅ Configure Hive for local storage
3. ✅ Setup project structure

### Phase 2: Data Layer
1. ✅ Create Expense model with Hive annotations
2. ✅ Create Currency Rate model
3. ✅ Implement Hive database service
4. ✅ Implement Currency API service
5. ✅ Create repositories

### Phase 3: BLoC Layer
1. ✅ Implement ExpenseBloc (CRUD operations, pagination)
2. ✅ Implement CurrencyBloc (fetch rates, convert amounts)
3. ✅ Implement DashboardBloc (filters, summaries)

### Phase 4: UI Layer
1. ✅ Create core constants (colors, text styles, icons)
2. ✅ Build Dashboard Screen
   - User profile header
   - Balance card with income/expenses
   - Filter dropdown
   - Paginated expense list
   - FAB for adding expenses
3. ✅ Build Add Expense Screen
   - Category selection
   - Amount input with currency selector
   - Date picker
   - Receipt upload
   - Save button

### Phase 5: Features
1. ✅ Implement pagination (10 items per page)
2. ✅ Implement currency conversion on save
3. ✅ Implement filters (This Month, Last 7 Days, etc.)
4. ✅ Handle loading, empty, and error states

### Phase 6: Testing
1. ✅ Unit tests for expense validation
2. ✅ Unit tests for currency calculation
3. ✅ Widget tests for key screens

### Phase 7: Documentation
1. ✅ Create comprehensive README.md
2. ✅ Add code comments
3. ✅ Document architecture decisions

## Key Technical Decisions

### Currency Conversion
- Use https://open.er-api.com/v6/latest/USD (no API key required)
- Store both original amount and USD converted amount
- Cache exchange rates locally to reduce API calls

### Pagination Strategy
- Local pagination (data stored in Hive)
- 10 items per page
- Infinite scroll implementation
- Filter-aware pagination

### Data Models
```dart
Expense {
  id: String
  category: String
  amount: double
  currency: String
  amountInUSD: double
  date: DateTime
  receiptPath: String?
  createdAt: DateTime
}
```

### Categories
- Groceries (shopping cart icon)
- Entertainment (game controller icon)
- Transportation (car icon)
- Rent (house icon)
- News Paper (newspaper icon)
- Gas (fuel icon)
- Shopping (shopping bag icon)

### Filters
- All Time
- This Month
- Last 7 Days
- Last 30 Days
- Custom Range (bonus)

## Design Specifications (from screenshot)

### Colors
- Primary Blue: #2D5BFF (or similar)
- Background: #F5F6FA
- Card White: #FFFFFF
- Text Dark: #1A1A1A
- Text Light: #8F92A1
- Income Green: #00D09E
- Expense Red/Pink: #FF6B9D

### Typography
- Header: Bold, 24-28px
- Balance: Bold, 32-36px
- Body: Regular, 14-16px
- Caption: Regular, 12-14px

### Components
- Rounded cards with subtle shadows
- Icon-based category selection
- Bottom navigation bar
- Floating action button for add expense

## Testing Strategy
1. Unit Tests:
   - Expense validation (required fields, amount > 0)
   - Currency conversion calculation
   - Date filtering logic
   - Pagination logic

2. Widget Tests:
   - Dashboard screen renders correctly
   - Add expense form validation
   - Category selection

## Known Limitations & Trade-offs
- Receipt upload stores local file path (not cloud storage)
- Currency rates cached for 24 hours to reduce API calls
- Pagination is local-only (all data loaded from Hive)
- No user authentication (single user app)

## Future Enhancements (Bonus)
- [ ] CI/CD with GitHub Actions
- [ ] Animated transitions
- [ ] CSV/PDF export
- [ ] Budget tracking
- [ ] Expense analytics/charts
- [ ] Multi-currency support with live rates
