import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/salary_model.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class AddSalaryScreen extends StatefulWidget {
  final String employeeUserId;
  final String employeeName;

  const AddSalaryScreen({
    super.key,
    required this.employeeUserId,
    required this.employeeName,
  });

  @override
  State<AddSalaryScreen> createState() => _AddSalaryScreenState();
}

class _AddSalaryScreenState extends State<AddSalaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _basicSalaryController = TextEditingController();
  final _allowanceController = TextEditingController(text: '0');
  final _bonusController = TextEditingController(text: '0');
  final _overtimePayController = TextEditingController(text: '0');

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String _status = 'approved';
  bool _isLoading = false;

  @override
  void dispose() {
    _basicSalaryController.dispose();
    _allowanceController.dispose();
    _bonusController.dispose();
    _overtimePayController.dispose();
    super.dispose();
  }

  double _calculateTotal() {
    final basic = double.tryParse(_basicSalaryController.text) ?? 0;
    final allowance = double.tryParse(_allowanceController.text) ?? 0;
    final bonus = double.tryParse(_bonusController.text) ?? 0;
    final overtime = double.tryParse(_overtimePayController.text) ?? 0;
    return basic + allowance + bonus + overtime;
  }

  double _calculateAfterTax(double total) {
    if (total <= 10000000) {
      return total * 0.9;
    } else {
      return total * 0.85;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('New Salary Record'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Employee Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                           BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, color: AppTheme.primaryColor),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Employee',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                widget.employeeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Date Selection
                     Text(
                      'Period',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedMonth,
                            decoration: const InputDecoration(
                              labelText: 'Month',
                              prefixIcon: Icon(Icons.calendar_month),
                            ),
                            items: List.generate(12, (index) {
                              final month = index + 1;
                              return DropdownMenuItem(
                                value: month,
                                child: Text('Month $month'),
                              );
                            }),
                            onChanged: (value) => setState(() => _selectedMonth = value!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedYear,
                            decoration: const InputDecoration(
                              labelText: 'Year',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            items: List.generate(5, (index) {
                              final year = DateTime.now().year - 2 + index;
                              return DropdownMenuItem(
                                value: year,
                                child: Text('$year'),
                              );
                            }),
                            onChanged: (value) => setState(() => _selectedYear = value!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Salary Details
                    Text(
                      'Payment Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _basicSalaryController,
                      decoration: const InputDecoration(
                        labelText: 'Basic Salary *',
                        prefixIcon: Icon(Icons.attach_money),
                        suffixText: 'VNĐ',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                         if (value == null || value.isEmpty) return 'Required';
                         if (double.tryParse(value) == null) return 'Invalid number';
                         return null;
                      },
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _allowanceController,
                      decoration: const InputDecoration(
                        labelText: 'Allowance',
                        prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                        suffixText: 'VNĐ',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bonusController,
                      decoration: const InputDecoration(
                        labelText: 'Bonus',
                        prefixIcon: Icon(Icons.card_giftcard),
                        suffixText: 'VNĐ',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _overtimePayController,
                      decoration: const InputDecoration(
                        labelText: 'Overtime Pay',
                        prefixIcon: Icon(Icons.access_time),
                        suffixText: 'VNĐ',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 24),

                    // Status
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'pending', child: Text('Pending')),
                        DropdownMenuItem(value: 'approved', child: Text('Approved')),
                        DropdownMenuItem(value: 'paid', child: Text('Paid')),
                      ],
                      onChanged: (value) => setState(() => _status = value!),
                    ),
                    const SizedBox(height: 32),

                    // Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade800, Colors.blue.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Gross',
                                style: TextStyle(color: Colors.white70, fontSize: 16),
                              ),
                              Text(
                                NumberFormat('#,##0', 'vi_VN').format(_calculateTotal()) + ' VNĐ',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Net Salary',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                NumberFormat('#,##0', 'vi_VN').format(_calculateAfterTax(_calculateTotal())) + ' VNĐ',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveSalary,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Save Salary Record', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _saveSalary() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final total = _calculateTotal();
      final afterTax = _calculateAfterTax(total);

      final existing = await FirebaseFirestore.instance
          .collection('salaries')
          .where('employeeId', isEqualTo: widget.employeeUserId)
          .where('month', isEqualTo: _selectedMonth)
          .where('year', isEqualTo: _selectedYear)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception('Salary for $_selectedMonth/$_selectedYear already exists!');
      }

      final salary = SalaryModel(
        id: '',
        employeeId: widget.employeeUserId,
        month: _selectedMonth,
        year: _selectedYear,
        basicSalary: double.parse(_basicSalaryController.text),
        allowance: double.parse(_allowanceController.text),
        bonus: double.parse(_bonusController.text),
        overtimePay: double.parse(_overtimePayController.text),
        totalSalary: total,
        afterTaxSalary: afterTax,
        status: _status,
        createdAt: DateTime.now().toIso8601String(),
      );

      await FirebaseFirestore.instance.collection('salaries').add(salary.toJson());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salary record added successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
