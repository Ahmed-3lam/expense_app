import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../../../currency/presentation/bloc/currency_bloc.dart';
import '../../../currency/presentation/bloc/currency_event.dart';
import '../../../currency/presentation/bloc/currency_state.dart';
import '../../domain/entities/expense.dart';
import '../widgets/category_selector.dart';

/// Add expense screen
class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  String? _selectedCategory;
  String _selectedCurrency = 'USD';
  DateTime _selectedDate = DateTime.now();
  String? _receiptPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateController.text = _formatDate(date);
      });
    }
  }

  Future<void> _pickReceipt() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _receiptPath = image.path;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);

      // Convert to USD using CurrencyBloc
      context.read<CurrencyBloc>().add(
        ConvertToUSD(amount: amount, fromCurrency: _selectedCurrency),
      );

      // Wait for conversion result
      await Future.delayed(const Duration(milliseconds: 500));

      double amountInUSD = amount;

      // Get the conversion result from state
      final currencyState = context.read<CurrencyBloc>().state;
      if (currencyState is CurrencyConverted) {
        amountInUSD = currencyState.convertedAmount;
      }

      // Create expense entity
      final expense = Expense(
        id: const Uuid().v4(),
        category: _selectedCategory!,
        amount: amount,
        currency: _selectedCurrency,
        amountInUSD: amountInUSD,
        date: _selectedDate,
        receiptPath: _receiptPath,
        createdAt: DateTime.now(),
      );

      // Add expense
      if (mounted) {
        context.read<ExpenseBloc>().add(AddExpense(expense));
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense added successfully'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate back
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add expense: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Add Expense', style: AppTextStyles.subHeader),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Dropdown (showing selected category)
              Text(
                'Categories',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory ?? 'Select category',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _selectedCategory != null
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textLight,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Amount Field
              Text(
                'Amount',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: '\$50,000',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textLight,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid amount';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Date Field
              Text(
                'Date',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Select date',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textLight,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Receipt Upload
              Text(
                'Attach Receipt',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickReceipt,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _receiptPath != null
                            ? 'Receipt attached'
                            : 'Upload image',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        _receiptPath != null
                            ? Icons.check_circle
                            : Icons.camera_alt_outlined,
                        color: _receiptPath != null
                            ? AppColors.success
                            : AppColors.textLight,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Category Grid Selector
              CategorySelector(
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),
              const SizedBox(height: 32),
              // Save Button
              CustomButton(
                text: 'Save',
                onPressed: _saveExpense,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
