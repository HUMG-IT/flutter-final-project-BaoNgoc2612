import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/employee_model.dart';
import '../providers/employee_provider.dart';
import '../services/backend_api_service.dart';
import '../theme/app_theme.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final EmployeeModel? employee;
  final bool isEditMode;

  const EmployeeDetailScreen({
    super.key,
    this.employee,
    this.isEditMode = false,
  });

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _positionController;
  late TextEditingController _salaryController;
  late TextEditingController _passwordController;
  Department _selectedDepartment = Department.it;
  EmployeeStatus _selectedStatus = EmployeeStatus.active;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _createAccount = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phone ?? '');
    _positionController = TextEditingController(text: widget.employee?.position ?? '');
    _salaryController = TextEditingController(text: widget.employee?.salary.toString() ?? '');
    _passwordController = TextEditingController();

    if (widget.employee != null) {
      _selectedDepartment = widget.employee!.department;
      _selectedStatus = widget.employee!.status;
      _selectedDate = widget.employee!.hireDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _salaryController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Employee' : 'Add Employee'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (widget.isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: _deleteEmployee,
            ),
        ],
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
                    if (widget.isEditMode)
                       Center(
                         child: Padding(
                           padding: const EdgeInsets.only(bottom: 24),
                           child: CircleAvatar(
                             radius: 50,
                             backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                             child: Text(
                               widget.employee?.name.substring(0, 1).toUpperCase() ?? '?',
                               style: const TextStyle(fontSize: 40, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                             ),
                           ),
                         ),
                       ),
                    
                    _buildSectionTitle('Personal Information'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle('Job Details'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _positionController,
                              decoration: const InputDecoration(
                                labelText: 'Position',
                                prefixIcon: Icon(Icons.work_outline),
                              ),
                              validator: (value) => value!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<Department>(
                              value: _selectedDepartment,
                              decoration: const InputDecoration(
                                labelText: 'Department',
                                prefixIcon: Icon(Icons.business_outlined),
                              ),
                              items: Department.values.map((dept) {
                                return DropdownMenuItem(
                                  value: dept,
                                  child: Text(dept.name.toUpperCase()),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedDepartment = value!),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<EmployeeStatus>(
                              value: _selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                prefixIcon: Icon(Icons.flag_outlined),
                              ),
                              items: EmployeeStatus.values.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status.name.toUpperCase()), // Simplified for now
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedStatus = value!),
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Hire Date',
                                  prefixIcon: Icon(Icons.calendar_today_outlined),
                                ),
                                child: Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                     _buildSectionTitle('Compensation'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextFormField(
                          controller: _salaryController,
                          decoration: const InputDecoration(
                            labelText: 'Basic Salary',
                            prefixIcon: Icon(Icons.attach_money),
                            suffixText: 'VNĐ',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ? 'Required' : null,
                        ),
                      ),
                    ),

                    if (!widget.isEditMode) ...[
                      const SizedBox(height: 24),
                      _buildSectionTitle('Account'),
                      Card(
                        child: Padding(
                           padding: const EdgeInsets.all(16),
                           child: Column(
                             children: [
                               CheckboxListTile(
                                title: const Text('Create Login Account'),
                                subtitle: const Text('Admin creates password for employee'),
                                value: _createAccount,
                                activeColor: AppTheme.primaryColor,
                                contentPadding: EdgeInsets.zero,
                                onChanged: (value) => setState(() => _createAccount = value ?? false),
                              ),
                              if (_createAccount) ...[
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    helperText: 'Min 6 characters',
                                    prefixIcon: Icon(Icons.lock_outline),
                                  ),
                                  obscureText: true,
                                  validator: _createAccount
                                      ? (value) => (value == null || value.length < 6) ? 'Min 6 chars' : null
                                      : null,
                                ),
                              ],
                             ],
                           ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saveEmployee,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          widget.isEditMode ? 'Update Employee' : 'Save Employee',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: AppTheme.lightTheme.copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        if (currentUserId == null) throw Exception('User not logged in');

        String employeeUserId = widget.employee?.userId ?? currentUserId;

        if (_createAccount && !widget.isEditMode) {
          final isHealthy = await BackendApiService.checkHealth();
          if (!isHealthy) {
             throw Exception('Backend server not running. Please start it.');
          }

          final result = await BackendApiService.createEmployeeAccount(
            email: _emailController.text,
            password: _passwordController.text,
            displayName: _nameController.text,
            role: 'employee',
          );

          if (!result['success']) throw Exception(result['error']);
          employeeUserId = result['uid'];

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account created successfully!'), backgroundColor: Colors.green),
            );
          }
        }

        final employee = EmployeeModel(
          id: widget.employee?.id ?? '',
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          department: _selectedDepartment,
          position: _positionController.text,
          salary: double.parse(_salaryController.text),
          hireDate: _selectedDate,
          status: _selectedStatus,
          userId: employeeUserId,
        );

        final provider = context.read<EmployeeProvider>();
        if (widget.isEditMode) {
          await provider.updateEmployee(employee);
        } else {
          await provider.addEmployee(employee);
        }

        if (mounted) Navigator.pop(context);
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

  Future<void> _deleteEmployee() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text(
          'Are you sure you want to delete this employee?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        final provider = context.read<EmployeeProvider>();
        
        // 1. Nếu nhân viên có tài khoản đăng nhập (userId != currentUserId của admin), 
        // có thể cần xóa tài khoản Auth trước qua Backend API
        // Tuy nhiên, logic hiện tại: 
        // - userId của employee có thể là userId của chính họ (nếu họ tự đăng ký/được tạo tk)
        // - hoặc là currentUserId của admin (nếu tạo employee nhưng chưa có tk auth riêng - logic cũ?)
        // Với logic mới (Add Employee -> Create Account), userId sẽ là UID của employee đó.
        
        final employeeUserId = widget.employee?.userId;
        final currentAdminId = FirebaseAuth.instance.currentUser?.uid;
        
        // Chỉ xóa Auth account nếu userId khác adminId (tránh tự xóa mình)
        if (employeeUserId != null && employeeUserId != currentAdminId) {
             // Kiểm tra Backend server
             final isHealthy = await BackendApiService.checkHealth();
             if (isHealthy) {
                 await BackendApiService.deleteEmployeeAccount(employeeUserId);
             } else {
                 // Nếu backend không chạy, cảnh báo nhưng vẫn cho phép xóa data local?
                 // Hoặc throw Exception?
                 // Tạm thời chỉ thông báo nhẹ và tiếp tục xóa data
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Warning: Backend server offline. Auth account not deleted.')),
                 );
             }
        }

        // 2. Xóa data trong Firestore
        await provider.delete(widget.employee!.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Employee deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Pop Detail Screen
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }
}
