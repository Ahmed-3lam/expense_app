import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_colors.dart';
import 'core/init/hive_initializer.dart';
import 'core/di/injection.dart';
import 'features/expense/presentation/bloc/expense_bloc.dart';
import 'features/expense/presentation/bloc/expense_event.dart';
import 'features/currency/presentation/bloc/currency_bloc.dart';
import 'features/currency/presentation/bloc/currency_event.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_event.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveInitializer.init();

  // Configure dependency injection
  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Expense BLoC
        BlocProvider<ExpenseBloc>(
          create: (context) => getIt<ExpenseBloc>()..add(const LoadExpenses()),
        ),
        // Currency BLoC
        BlocProvider<CurrencyBloc>(
          create: (context) =>
              getIt<CurrencyBloc>()..add(const LoadExchangeRates()),
        ),
        // Dashboard BLoC
        BlocProvider<DashboardBloc>(
          create: (context) =>
              getIt<DashboardBloc>()..add(const LoadDashboard()),
        ),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
