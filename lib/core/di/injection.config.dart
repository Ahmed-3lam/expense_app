// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/currency/data/datasources/currency_local_datasource.dart'
    as _i1010;
import '../../features/currency/data/datasources/currency_remote_datasource.dart'
    as _i380;
import '../../features/currency/data/repositories/currency_repository_impl.dart'
    as _i751;
import '../../features/currency/domain/repositories/currency_repository.dart'
    as _i87;
import '../../features/currency/domain/usecases/convert_currency_usecase.dart'
    as _i424;
import '../../features/currency/domain/usecases/get_exchange_rates_usecase.dart'
    as _i526;
import '../../features/currency/presentation/bloc/currency_bloc.dart' as _i313;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i509;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i665;
import '../../features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart'
    as _i1062;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../../features/expense/data/datasources/expense_local_datasource.dart'
    as _i272;
import '../../features/expense/data/repositories/expense_repository_impl.dart'
    as _i587;
import '../../features/expense/domain/repositories/expense_repository.dart'
    as _i31;
import '../../features/expense/domain/usecases/add_expense_usecase.dart'
    as _i864;
import '../../features/expense/domain/usecases/get_expenses_usecase.dart'
    as _i1063;
import '../../features/expense/presentation/bloc/expense_bloc.dart' as _i484;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i272.ExpenseLocalDataSource>(
        () => _i272.ExpenseLocalDataSource());
    gh.lazySingleton<_i1010.CurrencyLocalDataSource>(
        () => _i1010.CurrencyLocalDataSource());
    gh.lazySingleton<_i380.CurrencyRemoteDataSource>(
        () => _i380.CurrencyRemoteDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i31.ExpenseRepository>(
        () => _i587.ExpenseRepositoryImpl(gh<_i272.ExpenseLocalDataSource>()));
    gh.lazySingleton<_i87.CurrencyRepository>(
        () => _i751.CurrencyRepositoryImpl(
              gh<_i1010.CurrencyLocalDataSource>(),
              gh<_i380.CurrencyRemoteDataSource>(),
            ));
    gh.factory<_i864.AddExpenseUseCase>(
        () => _i864.AddExpenseUseCase(gh<_i31.ExpenseRepository>()));
    gh.factory<_i1063.GetExpensesUseCase>(
        () => _i1063.GetExpensesUseCase(gh<_i31.ExpenseRepository>()));
    gh.lazySingleton<_i665.DashboardRepository>(
        () => _i509.DashboardRepositoryImpl(gh<_i31.ExpenseRepository>()));
    gh.factory<_i526.GetExchangeRatesUseCase>(
        () => _i526.GetExchangeRatesUseCase(gh<_i87.CurrencyRepository>()));
    gh.factory<_i424.ConvertCurrencyUseCase>(
        () => _i424.ConvertCurrencyUseCase(gh<_i87.CurrencyRepository>()));
    gh.factory<_i484.ExpenseBloc>(() => _i484.ExpenseBloc(
          gh<_i31.ExpenseRepository>(),
          gh<_i864.AddExpenseUseCase>(),
          gh<_i1063.GetExpensesUseCase>(),
        ));
    gh.factory<_i313.CurrencyBloc>(() => _i313.CurrencyBloc(
          gh<_i526.GetExchangeRatesUseCase>(),
          gh<_i424.ConvertCurrencyUseCase>(),
        ));
    gh.factory<_i1062.GetDashboardSummaryUseCase>(() =>
        _i1062.GetDashboardSummaryUseCase(gh<_i665.DashboardRepository>()));
    gh.factory<_i652.DashboardBloc>(
        () => _i652.DashboardBloc(gh<_i1062.GetDashboardSummaryUseCase>()));
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
