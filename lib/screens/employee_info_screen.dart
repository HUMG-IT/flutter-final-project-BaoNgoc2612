import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

// Import for Salary Table logic if needed, but we can just use static logic or moved logic.
// The salary table generation logic was inside the widget locally. I'll keep it.

class EmployeeInfoScreen extends StatelessWidget {
  const EmployeeInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    // Helper to format currency
    String formatCurrency(double amount) {
       return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    }

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Information'),
        centerTitle: false,
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 100,
              color: AppTheme.primaryColor,
              child: Container(
                decoration: const BoxDecoration(
                   gradient: AppTheme.primaryGradient,
                   borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                   )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1), width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                            child: Text(
                              (user.displayName ?? '?')
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 28,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.position,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildStatusChip(user.status),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'Personal Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                         BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInfoTile(
                          Icons.email_outlined,
                          'Email',
                          user.email,
                        ),
                        const Divider(indent: 56),
                        _buildInfoTile(
                          Icons.phone_outlined,
                          'Phone',
                          user.phone,
                        ),
                        const Divider(indent: 56),
                        _buildInfoTile(
                          Icons.business_outlined,
                          'Department',
                          user.department.name.toUpperCase(),
                        ),
                        const Divider(indent: 56),
                         _buildInfoTile(
                          Icons.calendar_today_outlined,
                          'Join Date',
                          user.hireDate != null 
                              ? '${user.hireDate!.day}/${user.hireDate!.month}/${user.hireDate!.year}'
                              : 'N/A',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'Compensation',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade600, Colors.green.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Basic Monthly Salary',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${formatCurrency(user.baseSalary)} VNĐ',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                   Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'Salary History (Last 6 Months)',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSalaryTable(user, formatCurrency),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    Color bgColor;

    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green.shade700;
        bgColor = Colors.green.shade50;
        break;
      case 'onleave':
        color = Colors.orange.shade700;
        bgColor = Colors.orange.shade50;
        break;
      case 'terminated':
        color = Colors.red.shade700;
        bgColor = Colors.red.shade50;
        break;
      default:
        color = Colors.grey.shade700;
        bgColor = Colors.grey.shade50;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildSalaryTable(UserModel employee, String Function(double) formatCurrency) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> salaryHistory = [];
    final hireDate = employee.hireDate ?? DateTime.now();
    final salary = employee.baseSalary;

    for (int i = 0; i < 6; i++) {
      final month = DateTime(now.year, now.month - i, 1);

      if (month.isAfter(hireDate) ||
          (month.month == hireDate.month && month.year == hireDate.year)) {
        
        // Simple logic for illustration
        double actualSalary = salary;
        double bonus = salary * 0.1;
        double insurance = salary * 0.105;
        double tax = (salary - 11000000) * 0.1;
        if (tax < 0) tax = 0;

        double netSalary = actualSalary + bonus - insurance - tax;

        salaryHistory.add({
          'month': month,
          'netSalary': netSalary,
          'basicSalary': actualSalary,
          'bonus': bonus,
          'insurance': insurance,
          'tax': tax,
        });
      }
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: salaryHistory.length,
      itemBuilder: (context, index) {
        final salaryCalc = salaryHistory[index];
        final month = salaryCalc['month'] as DateTime;
        final netSalary = salaryCalc['netSalary'] as double;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(12),
             border: Border.all(color: Colors.grey.shade100),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(
              '${month.month}/${month.year}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            trailing: Text(
              '${formatCurrency(netSalary)} VNĐ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            children: [
               Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  children: [
                    const Divider(),
                    _buildSalaryRow('Basic Salary', salaryCalc['basicSalary'], formatCurrency),
                    _buildSalaryRow('Bonus (10%)', salaryCalc['bonus'], formatCurrency, isPositive: true),
                    _buildSalaryRow('Insurance (10.5%)', -salaryCalc['insurance'], formatCurrency, isNegative: true),
                    _buildSalaryRow('Tax', -salaryCalc['tax'], formatCurrency, isNegative: true),
                    const Divider(),
                    _buildSalaryRow('Net Salary', salaryCalc['netSalary'], formatCurrency, isBold: true),
                  ],
                ),
               ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSalaryRow(
    String label,
    double amount,
    String Function(double) formatCurrency, {
    bool isPositive = false,
    bool isNegative = false,
    bool isBold = false,
  }) {
    Color color = AppTheme.textPrimary;
    if (isPositive) color = Colors.green;
    if (isNegative) color = Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 15 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AppTheme.textSecondary,
            ),
          ),
          Text(
            '${amount >= 0 ? "" : "-"}${formatCurrency(amount.abs())} VNĐ',
            style: TextStyle(
              fontSize: isBold ? 15 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
