import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/salary_model.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  int _selectedYear = DateTime.now().year;
  final _currencyFormat = NumberFormat('#,##0', 'vi_VN');

  String _formatCurrency(double amount) {
    return '${_currencyFormat.format(amount)} VNĐ';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Consumer<LanguageProvider>(
          builder: (context, lang, _) => Text(lang.getText('salary_title')),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<LanguageProvider>(
                  builder: (context, lang, _) => Text(
                    lang.getText('select_year'),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left, color: Colors.white),
                        onPressed: () => setState(() => _selectedYear--),
                      ),
                      Text(
                        _selectedYear.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right, color: Colors.white),
                        onPressed: () => setState(() => _selectedYear++),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('salaries')
                  .where('employeeId', isEqualTo: currentUser?.uid)
                  .where('year', isEqualTo: _selectedYear)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text('Error loading data: ${snapshot.error}'),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final salaries = snapshot.data?.docs ?? [];
                // Sort client-side to avoid Firestore Index requirement
                salaries.sort((a, b) {
                  final sA = SalaryModel.fromJson(a.data() as Map<String, dynamic>);
                  final sB = SalaryModel.fromJson(b.data() as Map<String, dynamic>);
                  return sA.month.compareTo(sB.month);
                });

                if (salaries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No salary records for $_selectedYear',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: salaries.length,
                  itemBuilder: (context, index) {
                    final doc = salaries[index];
                    final salary = SalaryModel.fromJson(doc.data() as Map<String, dynamic>);
                    return _buildSalaryCard(salary);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryCard(SalaryModel salary) {
    Color statusColor;
    String statusText;

    switch (salary.status) {
      case 'paid':
        statusColor = Colors.green;
        statusText = Provider.of<LanguageProvider>(context).getText('paid');
        break;
      case 'approved':
        statusColor = Colors.blue;
        statusText = Provider.of<LanguageProvider>(context).getText('approved');
        break;
      case 'pending':
      default:
        statusColor = Colors.orange;
        statusText = Provider.of<LanguageProvider>(context).getText('pending');
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: Colors.black12,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Month ${salary.month}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '$_selectedYear',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatCurrency(salary.afterTaxSalary),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Column(
                children: [
                  Consumer<LanguageProvider>(
                    builder: (context, lang, _) => Column(
                      children: [
                        _buildDetailRow(lang.getText('basic_salary'), salary.basicSalary),
                        _buildDetailRow(lang.getText('allowance'), salary.allowance),
                        _buildDetailRow(lang.getText('bonus'), salary.bonus),
                        _buildDetailRow(lang.getText('overtime'), salary.overtimePay),
                        const Divider(height: 24),
                        _buildDetailRow(lang.getText('total_gross'), salary.totalSalary, isBold: true),
                        _buildDetailRow(
                          'Tax/Insurance', // TODO: Add to dictionary
                          -(salary.totalSalary - salary.afterTaxSalary),
                          color: Colors.red,
                        ),
                        const Divider(height: 24),
                        _buildDetailRow(
                          lang.getText('net_salary'),
                          salary.afterTaxSalary,
                          isBold: true,
                          color: Colors.green,
                          textSize: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, double amount, {bool isBold = false, Color? color, double? textSize}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: textSize ?? 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontSize: textSize ?? 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color ?? AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
