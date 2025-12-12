import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_provider.dart';
import '../providers/auth_provider.dart' as app_auth;
import '../models/employee_model.dart';
import '../theme/app_theme.dart';

class EmployeeInfoScreen extends StatefulWidget {
  const EmployeeInfoScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeInfoScreen> createState() => _EmployeeInfoScreenState();
}

class _EmployeeInfoScreenState extends State<EmployeeInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<app_auth.AuthProvider>();
      final userId = authProvider.user?.uid;
      if (userId != null) {
        context.read<EmployeeProvider>().loadEmployees(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<app_auth.AuthProvider>();
    final employeeProvider = context.watch<EmployeeProvider>();

    final currentUserId = authProvider.user?.uid;
    EmployeeModel? currentEmployee;

    if (currentUserId != null) {
      try {
        currentEmployee = employeeProvider.employees.firstWhere(
          (emp) => emp.userId == currentUserId,
        );
      } catch (e) {
        // Employee not found
      }
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
      body: currentEmployee == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.person_off_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Employee information not found',
                     style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
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
                                color: Colors.black.withOpacity(0.05),
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
                                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1), width: 2),
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                                  child: Text(
                                    currentEmployee.name
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
                                      currentEmployee.name,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentEmployee.position,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildStatusChip(currentEmployee.status),
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
                                color: Colors.black.withOpacity(0.02),
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
                                currentEmployee.email,
                              ),
                              const Divider(indent: 56),
                              _buildInfoTile(
                                Icons.phone_outlined,
                                'Phone',
                                currentEmployee.phone,
                              ),
                              const Divider(indent: 56),
                              _buildInfoTile(
                                Icons.business_outlined,
                                'Department',
                                currentEmployee.department.name.toUpperCase(),
                              ),
                              const Divider(indent: 56),
                               _buildInfoTile(
                                Icons.calendar_today_outlined,
                                'Join Date',
                                '${currentEmployee.hireDate.day}/${currentEmployee.hireDate.month}/${currentEmployee.hireDate.year}',
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
                                color: Colors.green.withOpacity(0.3),
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
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_formatCurrency(currentEmployee.salary)} VNĐ',
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
                        _buildSalaryTable(currentEmployee),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusChip(EmployeeStatus status) {
    Color color;
    Color bgColor;
    String text;

    switch (status) {
      case EmployeeStatus.active:
        color = Colors.green.shade700;
        bgColor = Colors.green.shade50;
        text = 'Active';
        break;
      case EmployeeStatus.onLeave:
        color = Colors.orange.shade700;
        bgColor = Colors.orange.shade50;
        text = 'On Leave';
        break;
      case EmployeeStatus.terminated:
        color = Colors.red.shade700;
        bgColor = Colors.red.shade50;
        text = 'Terminated';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
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
          color: AppTheme.primaryColor.withOpacity(0.1),
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

  Widget _buildSalaryTable(EmployeeModel employee) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> salaryHistory = [];

    for (int i = 0; i < 6; i++) {
      final month = DateTime(now.year, now.month - i, 1);

      if (month.isAfter(employee.hireDate) ||
          month.month == employee.hireDate.month &&
              month.year == employee.hireDate.year) {
        
        // Simple logic for illustration
        double actualSalary = employee.salary;
        double bonus = employee.salary * 0.1;
        double insurance = employee.salary * 0.105;
        double tax = (employee.salary - 11000000) * 0.1;
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
        final salary = salaryHistory[index];
        final month = salary['month'] as DateTime;
        final netSalary = salary['netSalary'] as double;
        
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
              '${_formatCurrency(netSalary)} VNĐ',
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
                    _buildSalaryRow('Basic Salary', salary['basicSalary']),
                    _buildSalaryRow('Bonus (10%)', salary['bonus'], isPositive: true),
                    _buildSalaryRow('Insurance (10.5%)', -salary['insurance'], isNegative: true),
                    _buildSalaryRow('Tax', -salary['tax'], isNegative: true),
                    const Divider(),
                    _buildSalaryRow('Net Salary', salary['netSalary'], isBold: true),
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
    double amount, {
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
            '${amount >= 0 ? "" : "-"}${_formatCurrency(amount.abs())} VNĐ',
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

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
