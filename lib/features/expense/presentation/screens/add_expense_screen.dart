import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
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
              // Category Selector
              CategorySelector(
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Amount Field
              Text(
                'Amount',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: AppTextStyles.bodyLarge,
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textLight,
                        ),
                        filled: true,
                        fillColor: AppColors.cardWhite,
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
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCurrency,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCurrency = value;
                            });
                          }
                        },
                        underline: const SizedBox(),
                        isExpanded: true,
                        style: AppTextStyles.bodyMedium,
                        items: CurrencyFormatter.getSupportedCurrencies().map((
                          currency,
                        ) {
                          return DropdownMenuItem<String>(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Date Field
              Text(
                'Date',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
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
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Receipt Upload
              Text(
                'Attach Receipt',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickReceipt,
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.cardWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.divider,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: _receiptPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_receiptPath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Upload Image',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                ),
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
